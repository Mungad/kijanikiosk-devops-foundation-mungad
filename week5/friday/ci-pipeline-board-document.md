# KijaniKiosk CI Pipeline: Board Presentation Notes

## Purpose of the Pipeline

The KijaniKiosk CI pipeline gives the team confidence that every change entering the platform has passed agreed quality checks before it becomes an approved software version. Instead of relying on manual checks, the pipeline automatically reviews code, builds the application, verifies its quality, and stores a versioned release package in the company registry.

For a financial services platform, this process reduces the risk of releasing software that contains defects, security problems, or unclear changes. Each successful release is connected to the exact code change that created it, making it easier to track, review, and recover when needed.

## What Happens When Code Changes Are Submitted

When a developer pushes new code, the pipeline begins a controlled sequence of checks. The pipeline runs inside an isolated environment so that every change receives the same evaluation regardless of where the developer worked.

The stages are:

| Pipeline Stage | What It Confirms                                                                                                          |
| -------------- | ------------------------------------------------------------------------------------------------------------------------- |
| Lint           | Confirms the code follows agreed quality and formatting standards before further work begins.                             |
| Build          | Confirms the application can be prepared into a usable package.                                                           |
| Verify         | Runs testing and security checks in parallel to confirm the application works correctly and does not contain known risks. |
| Archive        | Stores the successful build output and records its identity for traceability.                                             |
| Publish        | Creates a versioned release package and places it in the approved software registry.                                      |

The first stage protects time and resources by stopping early when code quality problems are found. If the code does not meet basic standards, there is no reason to continue with later checks.

After successful quality checks, the application is packaged with a unique version number. The version includes both the application release number and a reference to the specific code change that created it. This means the team can always identify which source code produced a particular package.

The final package is stored in Nexus, the organisation’s software registry. Nexus acts as a controlled storage location for approved application versions. Instead of replacing previous releases, each successful pipeline run creates a traceable version. This supports safer updates because teams can identify what changed between releases.

## Why Versioning Matters

Versioning creates accountability. In a financial services environment, knowing exactly which software version is running is essential for investigation, auditing, and recovery.

If an issue appears after a release, the team can identify the affected version, understand when it was created, and compare it with previous successful releases. Multiple versions can exist safely because each package has a unique identity linked to the original code change.

## What Happens When Something Goes Wrong

The pipeline is designed to stop automatically when a problem is discovered. A failed check prevents later stages from running because releasing an unverified package would create unnecessary risk.

For example, if code quality checks fail, the application will not move forward to building or publishing. If the application builds successfully but tests fail, the release process stops before the package reaches the registry. If security checks identify a serious issue, the package is blocked until the risk is understood and resolved.

This approach ensures that problems are identified as early as possible. Developers receive feedback before unreliable software reaches customers or internal users. The team can then fix the issue, rerun the pipeline, and continue only when all required checks pass.

The pipeline also protects sensitive information by using managed credentials instead of storing passwords directly in source files. Authentication details are provided only during the publishing step and are removed after use.

## Current Scope and Future Improvements

The KijaniKiosk CI pipeline currently provides automated validation, packaging, security checks, and controlled storage of application versions. It does not yet automatically deploy applications into production environments or monitor applications after release. Future improvements would include a continuous delivery process that safely promotes approved versions through testing and production environments, along with additional monitoring and automated rollback capabilities.

