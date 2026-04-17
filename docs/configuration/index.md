# Configuration Overview

Docmosis Tornado provides a flexible configuration model that allows the behaviour of the server to be customised for different environments and deployment models.

Configuration controls aspects such as:

* where templates are stored
* where temporary working files are written
* how the service is secured
* licensing information
* optional runtime behaviour

Because Tornado is designed to run in a variety of environments (direct install, container deployments, development systems, and production servers), configuration can be supplied through several different mechanisms.

The most common configuration methods are:

| Configuration Method    | Description                                                        |
| ----------------------- | ------------------------------------------------------------------ |
| Java system properties  | Configuration supplied when starting Tornado using `-D` options    |
| Environment variables   | Configuration supplied by the host system or container environment |
| Persisted configuration | Settings saved through the Tornado web administration console      |

When Tornado starts, these configuration sources are applied in a defined order of precedence. Settings provided directly on the Java command line override environment variables, and environment variables override previously saved configuration.

This layered configuration model allows administrators to manage configuration centrally while still allowing deployment-specific overrides when required.

The following pages describe the most common configuration areas used when deploying Tornado.

---
