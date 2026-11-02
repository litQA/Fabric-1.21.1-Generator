import java.lang.instrument.ClassFileTransformer;
import java.lang.instrument.Instrumentation;
import java.security.ProtectionDomain;

/**
 * Minimal (no-ASM) javaagent workaround for the DSH sandbox.
 *
 * Processes run at Low integrity here, so Files.isWritable() never reports
 * true. Since JDK 21 the zipfs implementation does:
 *
 *     boolean writeable = AccessController.doPrivileged(
 *             (PrivilegedAction<Boolean>) () -> Files.isWritable(zfpath));
 *     this.readOnly = !writeable;
 *
 * which makes every zip file system read-only and breaks Fabric Loom
 * (ReadOnlyFileSystemException while writing its mappings cache).
 *
 * This agent rewrites the single `invokestatic Files.isWritable` call inside
 * jdk.nio.zipfs.ZipFileSystem into `pop; iconst_1; nop` so zipfs always stays
 * writable. Same 3-byte instruction length, no constant pool changes, so no
 * stack map frames need adjusting.
 */
public class ZipWritableAgent2 {
    public static void premain(String args, Instrumentation inst) {
        inst.addTransformer(new ClassFileTransformer() {
            @Override
            public byte[] transform(ClassLoader loader, String className, Class<?> classBeingRedefined,
                                    ProtectionDomain protectionDomain, byte[] classfileBuffer) {
                if (!"jdk/nio/zipfs/ZipFileSystem".equals(className)) {
                    return null;
                }
                try {
                    byte[] patched = patch(classfileBuffer);
                    System.out.println("[zip-writable-agent] patched ZipFileSystem");
                    return patched;
                } catch (Throwable t) {
                    System.err.println("[zip-writable-agent] patch failed: " + t);
                    return null;
                }
            }
        });
    }

    private static byte[] patch(byte[] b) {
        // ---- parse constant pool ----
        int cpCount = u2(b, 8);
        int[] tag = new int[cpCount];
        int[] off = new int[cpCount];
        String[] utf8 = new String[cpCount];
        int[] classNameIdx = new int[cpCount];
        int[] natNameIdx = new int[cpCount];
        int[] natDescIdx = new int[cpCount];

        int p = 10;
        for (int i = 1; i < cpCount; i++) {
            int t = b[p] & 0xFF;
            tag[i] = t;
            off[i] = p + 1;
            switch (t) {
                case 1: {
                    int len = u2(b, p + 1);
                    utf8[i] = new String(b, p + 3, len, java.nio.charset.StandardCharsets.UTF_8);
                    p += 3 + len;
                    break;
                }
                case 3: case 4: p += 5; break;
                case 5: case 6: p += 9; i++; break;
                case 7: classNameIdx[i] = u2(b, p + 1); p += 3; break;
                case 8: p += 3; break;
                case 9: case 10: case 11: p += 5; break;
                case 12: natNameIdx[i] = u2(b, p + 1); natDescIdx[i] = u2(b, p + 3); p += 5; break;
                case 15: p += 4; break;
                case 16: p += 3; break;
                case 17: case 18: p += 5; break;
                case 19: case 20: p += 3; break;
                default: throw new IllegalStateException("bad cp tag " + t + " at " + p);
            }
        }

        // ---- find methodref java/nio/file/Files.isWritable(Path)Z ----
        int target = -1;
        for (int i = 1; i < cpCount; i++) {
            if (tag[i] != 10) continue;
            int cls = u2(b, off[i]);
            int nat = u2(b, off[i] + 2);
            if (cls <= 0 || nat <= 0 || cls >= cpCount || nat >= cpCount) continue;
            if (tag[cls] != 7 || tag[nat] != 12) continue;
            String cn = utf8[classNameIdx[cls]];
            String mn = utf8[natNameIdx[nat]];
            String md = utf8[natDescIdx[nat]];
            if ("java/nio/file/Files".equals(cn) && "isWritable".equals(mn)
                    && "(Ljava/nio/file/Path;)Z".equals(md)) {
                target = i;
                break;
            }
        }
        if (target < 0) throw new IllegalStateException("Files.isWritable methodref not found");

        // ---- replace invokestatic #target with pop; iconst_1; nop ----
        int hi = (target >> 8) & 0xFF, lo = target & 0xFF;
        int hits = 0;
        byte[] out = b.clone();
        for (int i = 0; i + 2 < out.length; i++) {
            if ((out[i] & 0xFF) == 0xB8 && (out[i + 1] & 0xFF) == hi && (out[i + 2] & 0xFF) == lo) {
                out[i] = 0x57;      // pop
                out[i + 1] = 0x04;  // iconst_1
                out[i + 2] = 0x00;  // nop
                hits++;
            }
        }
        if (hits != 1) throw new IllegalStateException("expected 1 call site, patched " + hits);
        return out;
    }

    private static int u2(byte[] b, int p) {
        return ((b[p] & 0xFF) << 8) | (b[p + 1] & 0xFF);
    }
}
