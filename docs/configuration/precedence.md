# Configuration Precedence

Because Tornado supports multiple configuration methods, it is possible for the same setting to be supplied in more than one location.

To ensure predictable behaviour, Tornado evaluates configuration sources in a defined order of precedence.

The configuration priority is:

```
1. Java System Properties
2. Environment Variables
3. Previously Saved Tornado Configuration
```

This means:

* Settings provided using **Java `-D` options** take highest priority
* Settings provided through **environment variables** override previously saved configuration
* Settings saved through the **web console** are used only when no other configuration overrides them

---

## Example Scenario

Consider the following configuration sources:

### Saved configuration

```
templatesDir=/data/templates
```

### Environment variable

```
DOCMOSIS_TEMPLATESDIR=/docmosis-template-store
```

### Java startup option

```
-DtemplatesDir=/opt/templates
```

In this case Tornado will use:

```
/opt/templates
```

because the Java system property has the highest priority.

---

## Why This Matters

Understanding configuration precedence is important when troubleshooting Tornado deployments.

For example:

* a Docker environment variable may override a setting saved in the console
* a Java startup parameter may override environment variables
* configuration changes in the console may appear to have no effect if overridden elsewhere

When diagnosing configuration issues, always check the configuration sources in order of precedence.

---

## Recommended Configuration Approach

For most deployments the following approach works well:

| Environment           | Recommended Configuration Method            |
| --------------------- | ------------------------------------------- |
| Development           | Web console or environment variables        |
| Production            | Environment variables or startup properties |
| Container deployments | Environment variables                       |

Using a consistent configuration method across environments helps simplify deployment and reduce unexpected configuration conflicts.

---