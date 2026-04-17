---

# **Deploying Docmosis Tornado with Docker Compose**

---

# **Overview**

As with most production systems, deployments often have unique requirements influenced by factors such as available resources, environment configuration, and security policies.

The example project provided in this guide is intended to demonstrate one approach to running Docmosis Tornado using Docker Compose. It is not intended to represent the only or universally correct deployment model.

Instead, this document aims to explain how Tornado can be installed and configured using Docker Compose while providing a working example that can be adapted to suit the requirements of your own environment.

Docker Compose allows Tornado to run in a containerised environment with clearly separated:

* application runtime  
* configuration  
* templates and assets  
* working data  
* persisted Tornado preferences

This deployment model provides a **repeatable and portable setup** suitable for development, testing, and production environments.

This guide focuses on how the components used in the example relate to Tornado and how Tornado can be configured using Docker Compose. It does not attempt to prescribe specific software versions for all environments.

---

# **Introduction**

Although Tornado can be started using a container image and the `docker run` command, Docker Compose provides a more structured and maintainable way to define how a Tornado environment should be built and operated.

By capturing the container configuration, runtime settings, and supporting assets in a Compose file and accompanying Dockerfile, the deployment becomes easier to understand, reproduce, and manage over time.

This can be particularly beneficial for Tornado deployments, which commonly involve multiple directories, configuration settings, and dependencies such as LibreOffice and fonts. Using Docker Compose allows these elements to be defined in a consistent, version-controlled deployment structure, helping teams deploy Tornado reliably across development, testing, and production environments while reducing the margin for configuration errors.

---

# **Quick Start — Running the Example**

## **The Project Structure**

The example deployment used in this guide is organised as follows:

```
project/
├── assets/
│   ├── fonts/
│   ├── libreoffice/
│   │   └── LibreOffice_7.6.6.1_Linux_x86-64_deb.tar.gz
│   ├── logging/
│   │   └── javaLogging.properties
│   ├── prefs/
│   │   └── prefs.xml
│   ├── templates/
│   └── tornado/
│       └── tornado.env
│
├── Dockerfile
└── docker-compose.yaml
```

**Note:** Tornado requires a valid licence key in order to start.

One method of adding your license- recommended for this example is to add it to the included `/assets/tornado/tornado.env` file. 

No further changes are required to start a working instance of Tornado.

---

## **Running the Example Deployment**

From the project root directory run:

```
docker compose up --build
```

After the container starts, Tornado will be available at:

```
http://localhost:8080
```

Check service status:

```
http://localhost:8080/api/status
```

---

# 

# 

# 

# **Understanding the Example Deployment**

# **Understanding Tornado** 

The example project uses a structured directory layout to separate the components required by Tornado. This layout helps clarify how Tornado, Docker, and the supporting resources interact during installation and runtime.

The project contains the following directories, each with a specific purpose:

### **Directory purposes**

---

| Directory | Purpose |
| :---- | :---- |
| `assets/templates` | Stores document templates and associated images used by Tornado. These are mounted into the container so templates can be updated without rebuilding the image. |
| `assets/fonts` | Optional custom fonts used during document rendering. Fonts must be available to LibreOffice to ensure documents render as expected. |
| `assets/logging` | Optional Java logging configuration. This example provides a custom logging configuration file. If omitted, Tornado will use the JVM’s default logging behaviour. |
| `assets/prefs` | Optional persisted Tornado configuration stored using Java Preferences. Mounting this directory allows settings created through the Tornado admin console to persist across container restarts. |
| `assets/tornado` | Contains runtime environment configuration contained in `tornado.env`. This file defines environment variables used when the container starts.  |
| `working` | Tornado working directory used for logs, temporary files, and document processing caches. This directory should normally be persisted outside the container. |

# **Tornado Configuration** 

Initially configuring Tornado can be challenging \- not only does Tornado support multiple configuration sources but these can be applied in a variety of ways with differing priorities. 

### **Recommended approach for deployments**

For Docker Compose deployments:

* use **environment variables** for primary configuration  
* use **Java system properties** for JVM settings or explicit overrides  
* treat **saved preferences** as optional persisted configuration

**Application of configuration precedence**

To begin with it is important to understand that configuration is applied in the following order (highest priority first):

`Java system properties`

`Environment variables`

`Previously saved Tornado configuration`

```
Highest precedence
┌───────────────────────────────────────────────┐
 Java system properties                     	   
 Example:                                      		  
 JAVA_TOOL_OPTIONS=-DtemplatesDir=/templates   		  
                                               		  
 Used for explicit overrides and JVM settings  		  
└───────────────────────────────────────────────┘
                      │ these override
                      ▼
┌───────────────────────────────────────────────┐
 Environment variables                     		  
 Example:                                      		  
 DOCMOSIS_TEMPLATESDIR=/docmosis-template-store		  
                                               		  
 Recommended primary configuration method      		  
└───────────────────────────────────────────────┘
                      │ these override
                      ▼
┌───────────────────────────────────────────────┐
 Previously saved configuration             		  
 Stored in Java Preferences                    		  
                                               		  
 ~/.java/.userPrefs/com/docmosis/webserver     		                                                  Created when using the Tornado admin console  		  
└───────────────────────────────────────────────┘
Lowest precedence
```

---

# 

# 

# 

# **How Configuration Is Supplied in Docker**

```
                 Configuration Sources
┌────────────────────────────────────────────────────────────────────────┐
Project Files
│
├── docker-compose.yaml (environment section)   
Defines container runtime configuration, environment variables, volume mounts, and network settings
├── tornado.env (env_file referenced by Compose)
Optional environment variable file containing configuration values such as license details or API keys
├── Dockerfile  
JAVA_TOOL_OPTIONS / JVM settings 

└── prefs directory 
Optional persisted Tornado configuration created through the Tornado admin console
        				│
        				▼
                 Docker Container Environment
┌────────────────────────────────────────────────────────────────────────┐
Environment Variables 
 Example: 
 DOCMOSIS_TEMPLATESDIR=/docmosis-template-store 
 
 Java System Properties 
 Example: 
 JAVA_TOOL_OPTIONS=-DtemplatesDir=/templates    
        				│
        				▼
 			Docmosis Tornado Runtime
┌────────────────────────────────────────────────────────────────────────┐
 Tornado reads configuration using precedence rules 
 1. Java System Properties 
 2. Environment Variables 
 3. Persisted Tornado Preferences 

│
▼
┌────────────────────────────────────────────────────────────────────────┐

Tornado Behaviour
```

---

# **Tornado Configuration Methods (3)**

1. ## **Java System Properties**

These are commonly used for:

* logging configuration  
* JVM tuning  
* debugging

Java properties are typically supplied through the `JAVA_TOOL_OPTIONS` environment variable.

When the container starts, the JVM automatically reads `JAVA_TOOL_OPTIONS` and applies the specified Java properties.

*Java properties override environment variables and persisted configuration.*

`Dockerfile`

```
JAVA_TOOL_OPTIONS=-Djava.util.logging.config.file=/docmosis-tornado/javaLogging.properties
```

2. ## **Environment Variables**

Environment variables are the **recommended configuration method** for container deployments. 

Tornado settings can be supplied using environment variables with the `DOCMOSIS_` prefix.

Using a separate environment file is common practice because it allows environment-specific or sensitive values to be kept outside the main Docker Compose configuration.. Typically those not wanting to be committed to source control (such as licence details or API keys) 

*Note that environment files referenced using the `env_file` directive in the docker-compose.yaml are different from the `.env` file automatically read by Docker Compose.* 

*The `env_file` directive explicitly injects variables into the container environment, whereas a `.env` file is used by Docker Compose for variable substitution within the Compose configuration itself.*

Example of environment variables defined directly in `docker-compose.yaml` 

`docker-compose.yaml` 

```
environment:
  DOCMOSIS_TEMPLATESDIR: /docmosis-template-store
  DOCMOSIS_WORKINGDIR: /var/docmosis/working
  DOCMOSIS_OFFICEDIR: /usr/lib/libreoffice
```

Example of environment variables referenced via an environment file such as `assets/tornado/tornado.env` (in our sample project)

`docker-compose.yaml` 

```
env_file:
 - ./assets/tornado/tornado.env
```

`assets/tornado/tornado.env`

```
DOCMOSIS_TEMPLATESDIR=/docmosis-template-store
DOCMOSIS_WORKINGDIR=/var/docmosis/working
```

3. ## **Persisted Tornado Preferences**

Persisted preferences are referenced internally by Tornado. These preferences are typically not used as a primary configuration method. When configuration changes are made via the Tornado admin console, the settings are stored using Java Preferences.

If the preferences directory is mounted as a persistent volume, these settings will survive container restarts.

They are stored in the container under:

```
~/.java/.userPrefs/com/docmosis/webserver
```

In Docker deployments this directory can be mounted to preserve configuration across container rebuilds.

Example: in docker compose under volumes

```
volumes:
  - ./assets/prefs:/root/.java/.userPrefs/com/docmosis/webserver
```

Persisted preferences are useful when:

* migrating an existing Tornado installation  
* pre-seeding configuration

---

# 

# **Mapping `DOCMOSIS_*` Environment Variables to Tornado Settings**

Typically variables are defined in the Docker Compose (`environment` section or in an external environment file itself referenced under the `env_file` directive.) 

```
environment:
DOCMOSIS_TEMPLATESDIR: /docmosis-template-store
```

Tornado configuration settings have internal names (such as `templatesDir` or `workingDir`) which are used by Tornado.

For example the use of the variable `DOCMOSIS_TEMPLATESDIR`

```
DOCMOSIS_TEMPLATESDIR: /docmosis-template-store
```

Will be internally interpreted by Tornado as:

```
templatesDir=/docmosis-template-store
```

When configuring Tornado using Docker environment variables, the equivalent settings are provided using the `DOCMOSIS_*` prefix. The table below shows how these environment variables map to the underlying Tornado configuration settings.

| Environment Variable | Tornado Configuration Property | Purpose |
| :---- | :---- | :---- |
| `DOCMOSIS_TEMPLATESDIR` | `templatesDir` | Template source directory |
| `DOCMOSIS_WORKINGDIR` | `workingDir` | Tornado working directory |
| `DOCMOSIS_OFFICEDIR` | `officeDir` | LibreOffice installation location |
| `DOCMOSIS_ADMINPW` | `adminPw` | Admin console password |
| `DOCMOSIS_ADMINPWALLOWBLANK` | `adminPwAllowBlank` | Allow blank admin password |
| `DOCMOSIS_ACCESSKEY` | `accessKey` | REST API access key |
| `DOCMOSIS_CUSTOMSETTINGS` | `customSettings` | Additional configuration values |
| `DOCMOSIS_KEY` | `key` | License key component |
| `DOCMOSIS_SITE` | `site` | License site component |
| `DOCMOSIS_TEMPLATEPREFIX` | `templatePrefix` | Template field prefix |
| `DOCMOSIS_TEMPLATESUFFIX` | `templateSuffix` | Template field suffix |
| `DOCMOSIS_INSTALLSAMPLES` | `installSamples` | Install sample templates at startup |

### **Note:**

These variables are normally defined in the Docker Compose `environment` section or in the `tornado.env` file referenced by `env_file`.

Java runtime settings should instead be provided as Java system properties using the `JAVA_TOOL_OPTIONS` environment variable.

```
JAVA_TOOL_OPTIONS=-Djava.util.logging.config.file=/docmosis-tornado/javaLogging.properties
```

---

# **Advanced Configuration — Custom Settings**

Defined either in the Docker Compose `environment` section or in the `tornado.env` file using the `DOCMOSIS_CUSTOMSETTINGS` environment variable the `customSettings` parameter allows additional Docmosis engine settings to be supplied to Tornado. 

These settings provide a mechanism for **configuring advanced engine behaviour** that is not exposed through standard Tornado configuration parameters.

`docker-compose.yaml`

```
environment:
 DOCMOSIS_CUSTOMSETTINGS: |-
   docmosis.allowLocalFileOverwrite=true
   docmosis.office.start.timeout=60000
```

Custom settings should only be applied when their **purpose and effect are clearly understood.** 

Wherever possible, standard Tornado configuration parameters should be used instead.

Custom settings are passed directly to the Docmosis engine. As a result, the set of supported keys may vary between Tornado versions or depend on specific features in use.

For this reason, custom settings should normally be applied only when they:

*  are documented in Docmosis documentation, or

*  are recommended by Docmosis Support.

---

# 

# **Example Docker Compose Configuration**

The following Docker Compose configuration defines how the Tornado container is built and executed.

Key elements include:

• building the container image using the provided Dockerfile  
 • supplying Tornado configuration through environment variables  
 • mounting directories for templates, fonts, and persisted preferences  
 • exposing the Tornado HTTP API on port 8080  
 • providing a health check to monitor container status

`docker-compose.yaml`

```
services:
  tornado:
    build:
      context: .
      dockerfile: Dockerfile
    image: docker-tornado:2.10.2-lo7.6.6.1
    env_file:
      - ./assets/tornado/tornado.env
    ports:
      - "${HOST_PORT:-8080}:8080"
    environment:
      DOCMOSIS_TEMPLATESDIR: /docmosis-template-store
      DOCMOSIS_WORKINGDIR: /var/docmosis/working
      DOCMOSIS_OFFICEDIR: /usr/lib/libreoffice
    volumes:
      - ./assets/templates:/docmosis-template-store:ro
      - ./assets/logging/javaLogging.properties:/docmosis-tornado/javaLogging.properties:ro
      - ./assets/prefs:/root/.java/.userPrefs/com/docmosis/webserver
      - ./assets/fonts:/usr/share/fonts/custom:ro
    healthcheck:
      test: ["CMD", "wget", "-qO-", "http://localhost:8080/api/status"]
      interval: 30s
      timeout: 5s
      retries: 5
```

---

# 

# 

# **Dockerfile Implementation**

The Dockerfile defines how the Tornado container image is built.  
The image installs the following components:

 • LibreOffice (used by Tornado for document conversion)  
 • Java runtime environment  
 • the Tornado application  
 • supporting configuration files such as logging configuration and fonts

---

The sections below describe the key installation steps included in the example Dockerfile.

# **Installing LibreOffice**

LibreOffice can be installed from local installation media (previously downloaded and provided) or using a remote source (providing a URL at build time)

## Installing LibreOffice from **Local Installation Media**

This is the approach used in our example project.

This approach ensures **controlled , fast and reproducible builds**. Placing the LibreOffice installation media locally (in assets/libreoffice directory) ensures that the download process of chosen installation media does not slow or halt our build step. Our Dockerfile simply points to the path containing our install media.

`Dockerfile`

```
COPY assets/libreoffice/LibreOffice_7.6.6.1_Linux_x86-64_deb.tar.gz /tmp/

RUN cd /tmp \
 && tar -xzf LibreOffice_7.6.6.1_Linux_x86-64_deb.tar.gz \
 && dpkg -i LibreOffice_*/DEBS/*.deb || true \
 && apt-get update \
 && apt-get -f install -y \
 && dpkg -i LibreOffice_*/DEBS/*.deb \
 && ln -sf /opt/libreoffice*/program/soffice /usr/bin/soffice \
 && SOFF_REAL="$(readlink -f /usr/bin/soffice)" \
 && PROG_DIR="$(dirname "$SOFF_REAL")" \
 && ROOT_DIR="$(dirname "$PROG_DIR")" \
 && mkdir -p /opt/libreoffice \
 && ln -sfn "$PROG_DIR" /opt/libreoffice/program \
 && ln -sfn "$ROOT_DIR" /opt/libreoffice \
 && ln -sfn "$ROOT_DIR" /usr/lib/libreoffice \
 && rm -rf /tmp/LibreOffice_* /var/lib/apt/lists/*
```

This creates a consistent LibreOffice path:

```
/usr/lib/libreoffice
```

which matches the Tornado `officeDir` configuration.

---

## Installing LibreOffice from Remote Source

LibreOffice can also be downloaded during the Docker image build \- keeping our project footprint light. Older LibreOffice archive servers may throttle downloads, which can significantly increase build time. In this example we provide a URL containing the install media.

```
ENV LIBREOFFICE_VERSION=7.5.9.2
ENV LIBREOFFICE_URL=https://downloadarchive.documentfoundation.org/libreoffice/old/${LIBREOFFICE_VERSION}/deb/x86_64/LibreOffice_${LIBREOFFICE_VERSION}_Linux_x86-64_deb.tar.gz

RUN echo "Installing LibreOffice ${LIBREOFFICE_VERSION}..." && \
    wget $LIBREOFFICE_URL && \
    tar -xf LibreOffice_${LIBREOFFICE_VERSION}_Linux_x86-64_deb.tar.gz && \
    cd LibreOffice_${LIBREOFFICE_VERSION}_Linux_x86-64_deb/DEBS && \
    dpkg -i *.deb || true && \
    apt-get install -f -y && \
    cd ../.. && \
    rm -rf LibreOffice_${LIBREOFFICE_VERSION}_Linux_x86-64_deb* && \
    ln -s /opt/libreoffice${LIBREOFFICE_VERSION%.*}/program/soffice /usr/bin/libreoffice
```

---

# **Installing Tornado**

```
ARG TORNADO_URL=https://resources.docmosis.com/images/SoftwareDownloads/Tornado/2.10.2/docmosisTornado2.10.2.zip

RUN wget -O /tmp/tornado.zip "$TORNADO_URL" \
 && unzip -d /tmp/tornado /tmp/tornado.zip \
 && find /tmp/tornado -name "docmosisTornado*.war" -exec mv {} /docmosis-tornado/docmosisTornado.war \; \
 && rm -rf /tmp/tornado /tmp/tornado.zip
```

---

# **Templates and Images**

When using a **local filesystem template source**, templates and images may be stored together.

Example:

```
assets/templates/
```

For cloud storage template sources, separate directories are required:

```
templates/
images/
```

---

# **Tornado Working Directory**

The working directory stores:

* logs  
* temporary files  
* document processing caches

Example:

```
DOCMOSIS_WORKINGDIR=/var/docmosis/working
```

Note : This directory should normally be mounted to persistent storage.

---

# **Health Monitoring**

Tornado can be monitored using the status endpoint:

```
http://localhost:8080/api/status
```

This endpoint provides a readiness check suitable for container health monitoring.

---

---

# **Operating Tornado**

Start Tornado:

```
docker compose up --build
```

Run in background:

```
docker compose up -d
```

View logs:

```
docker compose logs -f
```

Stop containers:

```
docker compose down
```

---

# 

# **Recommended Deployment Practices**

* Prefer environment-based configuration  
* Persist templates and working directories  
* Use Java properties only when necessary  
* Persist preferences only when required

---

# **Security Considerations**

Production deployments should ensure:

* license keys are not stored in container images  
* secrets are injected at runtime  
* admin console access is secured  
* API access keys are used  
* TLS is provided via a reverse proxy

---

