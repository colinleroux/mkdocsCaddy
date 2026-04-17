# Basic Configuration

A typical Tornado deployment requires only a small number of configuration settings to begin generating documents.

These settings define the core operating environment for the server and identify where key resources are located.

The most important settings are:

| Setting        | Purpose                                                   |
| -------------- | --------------------------------------------------------- |
| `templatesDir` | Location of document templates                            |
| `workingDir`   | Directory used for logs and temporary files               |
| `officeDir`    | Location of the LibreOffice installation                  |
| `adminPw`      | Password for accessing the Tornado administration console |
| `accessKey`    | API key required to access the Tornado REST service       |

These settings can be provided using several methods depending on how Tornado is deployed.

### Example: Java command line configuration

When starting Tornado directly, configuration can be provided using Java system properties.

```
-DtemplatesDir=/opt/docmosis/templates
-DworkingDir=/opt/docmosis/working
-DofficeDir=/usr/lib/libreoffice
```

### Example: Environment variables (Docker)

When running Tornado inside a container environment such as Docker, configuration is commonly supplied through environment variables.

```
DOCMOSIS_TEMPLATESDIR=/docmosis-template-store
DOCMOSIS_WORKINGDIR=/var/docmosis/working
DOCMOSIS_OFFICEDIR=/usr/lib/libreoffice
```

These variables are mapped internally to Tornado configuration properties.

Providing configuration through environment variables is particularly common in containerised deployments because it allows configuration to be managed externally from the application.

Once Tornado starts successfully with the required settings, further configuration can also be adjusted through the Tornado web console.

---