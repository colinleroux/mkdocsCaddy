# Understanding Tornado

Docmosis Tornado is a **document generation server** designed to run within your own infrastructure. Unlike the Docmosis cloud service, where the platform and its dependencies are fully managed by Docmosis, Tornado is an **on-premises or self-hosted solution**. This provides flexibility and control over how documents are generated and how the system is integrated into your environment, but it also means that the operation and maintenance of the platform become the responsibility of the organisation running it.

In a typical deployment, Tornado runs as a service within your environment and exposes a **REST API** that applications can call to generate documents. Client applications send a request containing a template reference and the data required to populate that template. Tornado then processes the request, merges the data with the template, and produces the final document in the requested format (such as PDF or Word).

The following simplified flow illustrates the typical lifecycle of a document generation request.

```
Application
    │
    │ REST API request
    │ (template + data)
    ▼
Docmosis Tornado
    │
    │ Template merge
    │ Document processing
    ▼
Rendering Engine
(Java + LibreOffice)
    │
    ▼
Generated Document
(PDF, DOCX, etc.)
    │
    ▼
Returned to Application
```

In this process, Tornado acts as the orchestration layer responsible for managing templates, applying data, and coordinating the underlying components required to render the final document.

Because Tornado runs within your own infrastructure, it depends on several supporting components provided by the host system. These include the Java runtime, the operating system environment, and LibreOffice, which is used to perform document conversions and rendering operations.

Understanding how these components work together helps explain how Tornado operates and how it can be installed, configured, and maintained in different environments.

The next section describes the **core components of the Tornado stack**, explaining the role of Java, LibreOffice, and the host operating system, and how they interact to support document generation.
