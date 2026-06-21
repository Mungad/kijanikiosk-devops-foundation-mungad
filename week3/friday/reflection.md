# Reflection

## 1. At what point during the project did you discover that two requirements were in conflict? Describe the conflict and what you learned from resolving it.

A conflict emerged when implementing both security hardening and service functionality. The configuration directory needed to be locked down using restrictive permissions, but the service accounts still needed access to shared resources such as logs. Simply restricting access would have prevented some services from functioning correctly. I resolved this by using Access Control Lists (ACLs), which allowed me to apply the principle of least privilege while still granting the specific permissions required by each service account. This taught me that security controls must be designed with operational requirements in mind rather than applied in isolation.

## 2. The hardening decisions document is written for Nia. Rewrite one sentence from that document in the technical language you would use if writing it for Tendo instead. What is lost and what is gained in the translation?

Business-friendly version:

"The configuration folder is protected so that only authorized system components can make changes."

Technical version:

"The /opt/kijanikiosk/config directory is restricted to mode 750, preventing unauthorized write access while allowing controlled access through ownership and group permissions."

What is gained is precision and implementation detail, making it easier for an engineer to verify the control. What is lost is accessibility, because a non-technical stakeholder may not understand Linux permission modes or filesystem ownership concepts.

## 3. Looking at the provisioning script as a whole, what is the single most fragile part of it, the part most likely to fail in a real production environment that differs slightly from your test VM? What would you need to know about the target environment to make that part robust?

The most fragile part of the script is the systemd service configuration. The current implementation assumes that systemd is present, enabled, and behaves consistently across environments. In a production environment, the target system might use a different init system, different security policies, or service accounts with different requirements. To make this robust, I would need information about the operating system version, init system, security policies, package availability, and organizational service-management standards. With that information, the script could include environment detection and conditional configuration rather than relying on assumptions from the test VM.
