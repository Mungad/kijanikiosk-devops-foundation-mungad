# KijaniKiosk Production Foundation Security Decisions

## Purpose

This production foundation was designed to reduce the likelihood that a single mistake, system failure, or security incident could affect the entire KijaniKiosk platform. The approach focuses on limiting access, reducing unnecessary exposure, improving accountability, and ensuring that operational issues can be detected and investigated quickly. Each control was selected because it addresses a specific business risk rather than simply increasing technical complexity.

A key design decision was separating responsibilities between the application, payments, and logging functions. By giving each function its own identity and permissions, an issue affecting one component is less likely to spread to another. This reduces the potential impact of credential theft, software defects, or unauthorized activity.

Another important decision was restricting access to sensitive information and operational resources. Not every service requires the same level of access, and broad permissions create opportunities for misuse. Limiting access to only what is required reduces the likelihood of accidental changes, unauthorized data exposure, and privilege abuse.

The platform also includes controls that improve operational visibility. Security incidents are difficult to investigate when records are incomplete or lost during routine maintenance. Persistent logging and controlled log retention improve the ability to perform audits, troubleshoot outages, and support compliance activities.

Network exposure was intentionally minimized. Publicly accessible services create opportunities for attackers to discover and exploit weaknesses. Only the services that need external connectivity are exposed, while internal functions remain restricted to trusted sources. This reduces the attack surface available to external actors.

Service isolation was strengthened through application hardening measures. These controls reduce the ability of a compromised process to affect other parts of the system or the operating environment. The result is a more resilient platform that can better contain the effects of individual failures or compromises.

The final area of focus was verification and monitoring. Security controls are only valuable when they can be validated. Automated verification confirms that required protections remain in place after deployment, while health monitoring provides visibility into the operational state of critical services. This allows issues to be identified early and addressed before they affect customers.

### Security Controls Summary

| Control                              | What it does                                                                        | Risk mitigated                                                                         |
| ------------------------------------ | ----------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------- |
| Dedicated Service Accounts           | Separates application, payments, and logging functions into independent identities. | Prevents compromise of one service from automatically granting access to others.       |
| Least Privilege Access               | Grants each service only the permissions required for its role.                     | Reduces damage caused by stolen credentials or misuse of privileges.                   |
| Shared Access Control Lists (ACLs)   | Provides controlled access to shared operational data.                              | Prevents unauthorized modification or disclosure of information.                       |
| Systemd Service Hardening            | Restricts what service processes can access or modify.                              | Limits the impact of application compromise or software vulnerabilities.               |
| Firewall Segmentation                | Restricts network access to approved sources and destinations.                      | Reduces exposure to unauthorized external connections and attacks.                     |
| Journal Persistence                  | Retains operational records across service interruptions and reboots.               | Prevents loss of evidence required for troubleshooting and investigations.             |
| Log Rotation Controls                | Manages log growth while preserving required access permissions.                    | Prevents operational failures caused by storage exhaustion or broken permissions.      |
| Health Monitoring Checks             | Records the operational status of critical services.                                | Improves detection of service outages and deployment issues.                           |
| Environment Configuration Separation | Keeps service configuration separate from application execution.                    | Reduces the risk of configuration errors affecting multiple services.                  |
| Verification and Compliance Checks   | Confirms that required controls are present after deployment.                       | Detects configuration drift and failed security controls before they become incidents. |

## Residual Risk

While the current production foundation significantly improves security and operational resilience, it does not eliminate all risk. These controls do not protect against vulnerabilities within application code, compromised administrator accounts, malicious insiders, supply chain attacks affecting third-party software, or business process failures. They also cannot prevent every form of denial-of-service activity or guarantee protection against previously unknown security weaknesses. Continued monitoring, secure software development practices, vulnerability management, backup strategies, and periodic security reviews remain necessary to maintain an acceptable risk posture as the platform evolves.
