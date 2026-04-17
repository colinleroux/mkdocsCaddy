# Advanced Configuration

In addition to the standard Tornado configuration parameters, Docmosis Tornado supports a range of **advanced configuration settings** that allow deeper control of the underlying document generation engine.

These settings are typically used to modify specific behaviours of the Docmosis engine, adjust internal processing behaviour, or enable specialised features required by certain deployment environments.

In most cases, **standard Tornado configuration parameters should be sufficient**, and advanced settings are not required.

Advanced configuration should only be used when:

* a specific behaviour needs to be adjusted
* a documented setting is required for a feature
* the change has been recommended by Docmosis Support

---

# Custom Engine Settings

Advanced behaviour in Tornado is controlled using **custom engine settings**.

These settings are passed directly to the Docmosis document generation engine and allow fine-grained control over internal processing behaviour.

Custom settings use the following format:

```text
docmosis.setting.name=value
```

Multiple settings can be supplied by separating them with newline characters.

Example:

```text
docmosis.setting.one=value1
docmosis.setting.two=value2
```

Because these values are passed directly to the engine, the available settings may vary between Tornado versions or depend on the features being used.

---

# Supplying Custom Settings

Custom settings can be supplied using the `customSettings` configuration parameter.

How this is provided depends on how Tornado is deployed.

---

## Using Environment Variables (Docker)

In container deployments, custom settings are typically supplied using the `DOCMOSIS_CUSTOMSETTINGS` environment variable.

Example:

```yaml
environment:
  DOCMOSIS_CUSTOMSETTINGS: |-
    docmosis.allowLocalFileOverwrite=true
    docmosis.office.start.timeout=60000
```

The YAML `|-` syntax allows multiple lines to be passed as a single environment variable.

---

## Using Java Startup Parameters

Custom settings can also be provided as Java system properties when starting Tornado.

Example:

```bash
-DcustomSettings="docmosis.setting.one=value1\ndocmosis.setting.two=value2"
```

Because Java system properties have higher configuration precedence, values supplied in this way will override settings supplied through environment variables.

---

# When Advanced Settings Are Used

Advanced settings are most commonly used to:

* adjust LibreOffice startup behaviour
* modify document processing timeouts
* enable specialised rendering behaviour
* control internal engine features

These scenarios are relatively uncommon and are usually required only in specialised deployments or when troubleshooting specific issues.

---

# Important Considerations

Advanced configuration settings are passed directly to the Docmosis engine and may influence internal behaviour.

For this reason:

* not all settings are intended for general use
* some settings may change behaviour significantly
* unsupported settings may change between versions

Before applying custom settings, it is important to:

* understand the purpose of the setting
* understand the potential side effects
* verify compatibility with the Tornado version being used

---

# Warning

Advanced configuration should only be applied when the purpose and effect of the setting are clearly understood.

Incorrect configuration may lead to unexpected behaviour in document generation, performance issues, or incompatibility with future Tornado versions.

Where possible, use the **standard Tornado configuration parameters** instead of custom engine settings.

If a particular configuration change is required and its behaviour is unclear, it is recommended to consult the official documentation or contact **Docmosis Support** before applying the setting.

!!! warning
    Advanced configuration settings modify the behaviour of the Docmosis engine.  
    These settings should only be applied when their purpose and impact are fully understood.

