# Fault Injection Log

| Stage Faulted | Fault Introduced | Observed Behaviour | Why This Is Correct |
|---|---|---|---|
| Lint | Introduced ESLint error | Build stopped at Lint. Build, Verify, Archive and Publish skipped. | Invalid code style should fail before consuming build resources. |
| Build | Broke build command | Lint passed, Build failed. Verify, Archive and Publish skipped. | Failed builds should not continue to testing or publishing. |
| Test | Added failing Jest test | Lint and Build passed. Test branch failed. Publish skipped. | Code must pass tests before release. |
| Security Audit | Added high vulnerability dependency | Lint and Build passed. Security Audit failed. Publish skipped. | Vulnerable packages should not reach the registry. |
| Publish | Used invalid Nexus credentials | All previous stages passed. Publish failed. Artifact was not released. | Publishing failures protect the registry from incomplete releases. |
