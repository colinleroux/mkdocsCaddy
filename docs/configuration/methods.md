# Configuration Methods

Docmosis Tornado supports several methods for supplying configuration settings. This flexibility allows Tornado to operate in a wide variety of environments, including direct installations, containerised deployments, and automated infrastructure environments.

Configuration can be supplied using the following mechanisms:

| Method                  | Typical Usage                                                  |
| ----------------------- | -------------------------------------------------------------- |
| Java system properties  | Settings supplied when starting Tornado using `-D` options     |
| Environment variables   | Settings supplied by the operating system or container runtime |
| Persisted configuration | Settings saved through the Tornado web administration console  |

Each approach is suited to different operational models.

---

## Java System Properties

Java system properties allow configuration to be supplied when starting the Tornado server.

This method is commonly used when Tornado is started using scripts or application server startup commands.

Example:

```
-DtemplatesDir=/opt/docmosis/templates
-DworkingDir=/opt/docmosis/working
-DofficeDir=/usr/lib/libreoffice
```

Because these values are supplied directly to the Java runtime, they are often used when administrators need to override configuration at startup.

---

## Environment Variables

Environment variables are frequently used when deploying Tornado in container environments such as Docker.

In these environments, Tornado configuration settings are typically provided using variables prefixed with `DOCMOSIS_`.

Example:

```
DOCMOSIS_TEMPLATESDIR=/docmosis-template-store
DOCMOSIS_WORKINGDIR=/var/docmosis/working
DOCMOSIS_OFFICEDIR=/usr/lib/libreoffice
```

Internally, Tornado maps these environment variables to their equivalent configuration properties.

For example:

| Environment Variable    | Tornado Property |
| ----------------------- | ---------------- |
| `DOCMOSIS_TEMPLATESDIR` | `templatesDir`   |
| `DOCMOSIS_WORKINGDIR`   | `workingDir`     |
| `DOCMOSIS_OFFICEDIR`    | `officeDir`      |
| `DOCMOSIS_ADMINPW`      | `adminPw`        |
| `DOCMOSIS_ACCESSKEY`    | `accessKey`      |

Environment variables allow configuration to be managed outside the Tornado application itself, which is particularly useful for automated deployment pipelines and container orchestration systems.

---

## Web Administration Console

Tornado also allows configuration settings to be adjusted through the **Tornado Web Administration Console**.

Once Tornado is running, administrators can log into the console and modify many configuration settings through the web interface.

When changes are saved through the console, Tornado stores these settings internally and reuses them when the server is restarted.

This approach can be useful for adjusting settings in development or testing environments without modifying startup scripts.

---

