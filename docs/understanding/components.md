# Core Components of the Tornado Stack

Docmosis Tornado runs as a server application within your infrastructure and relies on several supporting components provided by the host system. These components form the **Tornado runtime stack**, which together enable document generation and conversion.

At a high level, Tornado depends on three core layers:

* the **operating system** hosting the service
* the **Java runtime** used to execute the Tornado application
* **LibreOffice**, which performs document rendering and conversion

Understanding the role of each component helps clarify how Tornado processes document generation requests and why these dependencies are required.

---

# Overview of the Tornado Runtime Stack

The following diagram illustrates the relationship between the core components involved in document generation.

```
Application
     │
     │ REST API Request
     │ (template + data)
     ▼
┌─────────────────────────────┐
│       Docmosis Tornado      │
│       (Java Application)    │
└──────────────┬──────────────┘
               │
               ▼
┌─────────────────────────────┐
│         LibreOffice         │
│  Document rendering engine  │
└──────────────┬──────────────┘
               │
               ▼
┌─────────────────────────────┐
│       Operating System      │
│  File system, processes,    │
│  networking, resources      │
└─────────────────────────────┘
```

In this architecture, Tornado orchestrates the document generation process while relying on the underlying runtime and operating system to perform the necessary rendering and system operations.

---

# Java Runtime Environment

Docmosis Tornado is implemented as a **Java application** and therefore requires a compatible **Java Runtime Environment (JRE)** to run.

The Java runtime is responsible for:

* executing the Tornado server application
* managing memory allocation and garbage collection
* providing networking and threading capabilities
* supporting the REST API used by client applications

When Tornado starts, the Java runtime loads the Tornado application and begins listening for incoming API requests. Each request is processed within the Java runtime before the document generation process is initiated.

Because Tornado runs within the Java environment, certain configuration options may also be provided as **Java system properties**. These properties allow advanced configuration such as logging behaviour or JVM tuning.

---

# LibreOffice

LibreOffice is used by Tornado as the **document rendering and conversion engine**.

Many document templates are authored using formats such as:

* Microsoft Word (DOCX)
* OpenDocument Text (ODT)

LibreOffice provides the capability to:

* interpret and process these document formats
* render the merged template content
* convert documents into final output formats such as **PDF**

During document generation, Tornado communicates with a running LibreOffice instance to perform the rendering process. The final document is then returned to Tornado and delivered back to the requesting application.

Because of this dependency, a compatible version of LibreOffice must be available to the Tornado environment.

---

# Operating System

The **host operating system** provides the environment in which both the Java runtime and LibreOffice execute.

Typical supported environments include:

* Linux
* Windows

The operating system provides:

* process management
* file system access
* networking
* system resources such as CPU and memory

Tornado relies on the operating system to manage its working directories, temporary files, and network communications.

---

# Independent Component Management

An important characteristic of the Tornado stack is that these components are **loosely coupled**. This means that each component can typically be updated or maintained independently.

For example:

* the **Java runtime** may be updated to a newer supported version
* **LibreOffice** may be upgraded to address rendering improvements
* the **operating system** may receive security or system updates

As long as the versions used remain compatible with Tornado, these updates can usually be applied without requiring changes to the Tornado application itself.

This flexibility allows organisations to maintain their systems according to their internal policies while continuing to run Tornado.

---

# Transition to Deployment Options

Now that the core components of the Tornado runtime stack have been introduced, the next section examines the **different deployment approaches available for Tornado**.

These include:

* direct installation on Windows or Linux systems
* container-based deployments using Docker
* orchestrated deployments using Docker Compose

Each approach provides different operational characteristics and may be preferred depending on the requirements of the environment in which Tornado will run.
