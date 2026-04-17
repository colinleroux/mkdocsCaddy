

# Deployment Options for Docmosis Tornado

Docmosis Tornado can be deployed in several different ways depending on the requirements of the environment in which it will run. Because Tornado is a **self-hosted document generation server**, organisations have flexibility in how the service is installed, configured, and maintained within their infrastructure.

The Tornado installation package supports both **manual installation** and **container-based deployment** approaches. 

The most common deployment options include:

* Direct installation on **Windows**
* Direct installation on **Linux**
* **Docker container** deployment
* **Docker Compose** deployments for structured container environments

Each option provides the same core Tornado functionality, but differs in how the runtime environment and dependencies are managed.

---

# Direct Installation (Windows or Linux)

The traditional installation approach involves running Tornado directly on a host system.

In this model the Tornado application package is extracted to a directory on the server, and the provided startup scripts are used to launch the service. 

For example:

```
Windows
C:\Docmosis\Tornado
```

```
Linux
/opt/docmosis/tornado
```

Tornado is then started using the supplied scripts:

```
startTornado.bat
```

or

```
startTornado.sh
```

This method provides a straightforward installation and may be suitable for environments where container technologies are not used.

### Advantages

* Simple and familiar installation model
* Minimal infrastructure requirements
* Easy to run on existing application servers

### Considerations

* Dependencies such as **Java and LibreOffice must be installed and maintained manually**
* Environment configuration may vary between systems
* Replicating identical environments across development, test, and production systems can be more difficult

---

# Docker-Based Deployment

Docker provides a containerised runtime environment for Tornado.

Instead of installing Java, LibreOffice, and Tornado directly on the host system, these components are packaged into a **container image**. The container can then be started consistently on any system running Docker.

The Tornado installation guide notes that Docker makes it easy to start Tornado without the detailed manual installation process. 

In a Docker deployment, the Tornado runtime stack typically includes:

* the operating system environment (inside the container image)
* the Java runtime
* LibreOffice
* the Tornado application

Because these components are packaged together, the container behaves the same regardless of the host system.

### Advantages

* Consistent runtime environments
* Simplified dependency management
* Easy replication across environments
* Isolation from the host operating system

### Considerations

* Requires Docker infrastructure
* Requires basic container management knowledge

---

# Why Docker Is Commonly Used

Docker has become a popular deployment approach because it addresses several operational challenges associated with managing application dependencies.

Without containers, environments must be configured manually. Differences in Java versions, LibreOffice installations, or system libraries can sometimes lead to inconsistent behaviour between environments.

Containers solve this problem by packaging the entire runtime environment into a single image that can be deployed consistently across multiple systems.

For Tornado deployments this approach is particularly beneficial because the document generation process depends on multiple components working together reliably.

Docker therefore provides:

* **reproducible environments**
* **simplified dependency management**
* **portable deployments**
* **consistent behaviour across systems**

---

# Using Docker Compose

Docker Compose builds on Docker by providing a way to define and run containerised applications using a structured configuration file.

Instead of launching a container using a long command with many parameters, Docker Compose allows the container configuration to be described in a **compose file**.

For example, a typical Tornado container may require configuration such as:

* port mappings
* environment variables
* volume mounts
* runtime options

Using Docker directly, these options may appear in a long command:

```
docker run -d \
 -p 8080:8080 \
 -e DOCMOSIS_TEMPLATESDIR=/docmosis-template-store \
 -v ./templates:/docmosis-template-store
```

Docker Compose replaces this with a structured configuration file:

```
docker-compose.yaml
```

Once defined, the environment can be started using a simple command:

```
docker compose up
```

---

# Benefits of Docker Compose for Tornado Deployments

Docker Compose provides several advantages when deploying Tornado.

### Structured Configuration

All runtime configuration is stored in a single configuration file rather than embedded in long command lines.

### Reproducible Environments

The same configuration file can be used to deploy identical environments across development, testing, and production systems.

### Version-Controlled Infrastructure

Docker Compose files can be stored alongside application code in source control, making deployment environments easier to maintain and audit.

### Simplified Deployment

Starting the service becomes a simple operation:

```
docker compose up
```

### Clear Separation of Components

Docker Compose makes it easier to organise related resources such as:

* templates
* fonts
* configuration
* working directories

This structured approach is particularly useful for Tornado deployments where multiple supporting resources must be mounted into the container.

---

# Choosing a Deployment Approach

The appropriate installation method depends largely on the operational practices of the organisation running Tornado.

Direct installation may be appropriate for environments where container technologies are not used.

Container-based deployments using Docker or Docker Compose are often preferred in modern environments because they provide greater consistency and easier environment management.

In many cases, Docker Compose offers a good balance between simplicity and structure, making it a practical choice for running Tornado in both development and production environments.

---

