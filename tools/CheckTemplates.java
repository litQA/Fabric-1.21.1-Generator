import freemarker.template.Configuration;
import freemarker.template.Template;
import freemarker.template.TemplateExceptionHandler;

import java.io.File;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;
import java.util.stream.Stream;

/**
 * Parses every FreeMarker template shipped by the generator without executing it.
 * The check reports templates that contain syntax errors such as unbalanced directives.
 */
public final class CheckTemplates {

    public static void main(String[] args) throws Exception {
        Path root = Paths.get(args.length > 0 ? args[0] : "fabric-1.21.1").toAbsolutePath().normalize();
        if (!Files.isDirectory(root)) {
            System.err.println("Template root does not exist: " + root);
            System.exit(2);
        }

        Configuration configuration = new Configuration(Configuration.VERSION_2_3_35);
        configuration.setDefaultEncoding(StandardCharsets.UTF_8.name());
        configuration.setTemplateExceptionHandler(TemplateExceptionHandler.RETHROW_HANDLER);
        configuration.setLogTemplateExceptions(false);
        configuration.setWrapUncheckedExceptions(true);

        List<Path> templates;
        try (Stream<Path> stream = Files.walk(root)) {
            templates = stream.filter(Files::isRegularFile)
                    .filter(path -> path.getFileName().toString().endsWith(".ftl"))
                    .sorted()
                    .collect(Collectors.toList());
        }

        List<String> failures = new ArrayList<>();
        for (Path template : templates) {
            String relative = root.relativize(template).toString().replace(File.separatorChar, '/');
            try {
                String content = Files.readString(template, StandardCharsets.UTF_8);
                new Template(relative, content, configuration);
            } catch (Exception exception) {
                String message = exception.getMessage() == null ? exception.toString() : exception.getMessage();
                failures.add(relative + " -> " + message.replace('\n', ' ').replace('\r', ' '));
            }
        }

        System.out.println("Parsed templates: " + templates.size());
        System.out.println("Failed templates: " + failures.size());
        for (String failure : failures) {
            System.out.println("  FAIL " + failure);
        }
        if (!failures.isEmpty()) {
            System.exit(1);
        }
    }
}
