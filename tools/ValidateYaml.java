import org.snakeyaml.engine.v2.api.Load;
import org.snakeyaml.engine.v2.api.LoadSettings;

import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;
import java.util.stream.Stream;

/**
 * Loads every YAML definition shipped by the generator with the same engine MCreator uses.
 */
public final class ValidateYaml {

    public static void main(String[] args) throws Exception {
        Path root = Paths.get(args.length > 0 ? args[0] : "fabric-1.21.1").toAbsolutePath().normalize();
        if (!Files.isDirectory(root)) {
            System.err.println("Generator root does not exist: " + root);
            System.exit(2);
        }

        Load load = new Load(LoadSettings.builder().setAllowDuplicateKeys(false).build());

        List<Path> files;
        try (Stream<Path> stream = Files.walk(root)) {
            files = stream.filter(Files::isRegularFile)
                    .filter(path -> path.getFileName().toString().endsWith(".yaml"))
                    .sorted()
                    .collect(Collectors.toList());
        }

        List<String> failures = new ArrayList<>();
        for (Path file : files) {
            String relative = root.relativize(file).toString().replace('\\', '/');
            try {
                load.loadFromString(Files.readString(file, StandardCharsets.UTF_8));
            } catch (Exception exception) {
                String message = exception.getMessage() == null ? exception.toString() : exception.getMessage();
                failures.add(relative + " -> " + message.split("\n")[0]);
            }
        }

        System.out.println("Loaded YAML files: " + files.size());
        System.out.println("Failed YAML files: " + failures.size());
        for (String failure : failures) {
            System.out.println("  FAIL " + failure);
        }
        if (!failures.isEmpty()) {
            System.exit(1);
        }
    }
}
