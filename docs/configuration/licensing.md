# Licensing

Docmosis Tornado requires a valid license to run in licensed mode.

The license identifies the authorised deployment and enables the full functionality of the Tornado server.

Licensing information consists of two components:

| Component       | Description                          |
| --------------- | ------------------------------------ |
| License Key     | A unique key issued by Docmosis      |
| Site Identifier | Identifies the licensed organisation |

These values must be provided when Tornado starts.

Example configuration:

```
key=YOUR_LICENSE_KEY
site=YOUR_SITE_IDENTIFIER
```

In container environments the same information is typically supplied using environment variables:

```
DOCMOSIS_KEY=docmosis.key=XXXX-XXXX-XXXX
DOCMOSIS_SITE=docmosis.site=Example Organisation
```

Once Tornado starts with valid licensing information, the server will operate in licensed mode and can be accessed through the web administration console or REST API.

If a valid license is not supplied, Tornado will operate in **trial mode**, which may include usage limitations.

For security reasons license information should be stored securely and only made available to authorised deployment environments.