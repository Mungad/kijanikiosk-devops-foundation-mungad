# Week 5 CI Pipeline Reflection

## 1. At what point this week did you discover that two requirements were in tension with each other?

The biggest tension I discovered was between publishing artifacts securely and making the pipeline simple to configure. The pipeline needed to publish packages to Nexus automatically, but the requirement also stated that credentials must never appear in the Jenkinsfile, git history, or build logs.

Initially, testing the Nexus connection was easier by using direct credentials while troubleshooting. However, this created a risk because any secret stored in source code could be exposed. I chose to prioritise credential security by using Jenkins credential management with `withCredentials`. The pipeline receives the credentials only during the publishing step, creates the temporary authentication configuration, publishes the package, and removes the configuration afterwards.

This decision made the setup slightly more complex, but it created a safer design that would be appropriate for a financial services platform. The final pipeline separates authentication details from the application code while still allowing automated releases.

## 2. The board document is written for Nia. Rewrite one sentence from that document in technical language you would use with Osei or in a Jenkinsfile comment.

Board audience version:

"Every time a developer pushes new code, the pipeline automatically reviews the change, verifies quality, and stores an approved version of the application."

Technical engineering version:

"The Jenkins declarative pipeline triggers on repository changes, executes linting, build, parallel test and security audit stages inside a pinned Node Docker agent, archives artifacts, and publishes a versioned npm package to Nexus using managed credentials."

The information is the same in both versions: a code change is checked automatically before becoming an available release. The difference is the level of detail. The board version explains the business value and risk reduction without requiring engineering knowledge. The technical version explains the implementation details, tools, and execution flow required by the engineering team.

## 3. Looking at the complete pipeline as a system: if KijaniKiosk grows from four developers to forty, which single part would break first?

The first part likely to experience problems would be the publishing and artifact management process. As more developers contribute changes, more pipeline runs would create more packages and increase the number of releases stored in Nexus. Without additional controls, the registry could become difficult to manage and developers could create unnecessary duplicate versions.

The publishing process would need improvements such as stronger release policies, automated cleanup of unused artifacts, and clearer versioning rules. The pipeline may also need better concurrency management so multiple teams can work without blocking each other's releases.

Another improvement would be adding stronger ownership around package promotion. Instead of every successful build immediately becoming a release candidate, future versions of the pipeline could introduce approval steps between testing environments and production deployment.

This week's pipeline creates a strong foundation because it already provides automated validation, traceability, security checks, and controlled artifact storage. The next challenge is scaling the process so that increased development activity does not reduce reliability or visibility.

