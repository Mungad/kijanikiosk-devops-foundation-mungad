# KijaniKiosk Board Demonstration Script

[Stage Direction: Begin pipeline demonstration. Display the deployment dashboard.]

Good morning. Today I will demonstrate how our deployment process introduces a new version of the payments service while protecting customer availability.

[Stage Direction: Start deployment of version v1.4.0.]

The new version is prepared alongside the current version without interrupting customers. At this point, both versions are available, allowing us to verify the new release before anyone begins using it.

[Stage Direction: Switch live traffic to the new version.]

The system has now directed customer requests to the new version. The previous version remains available in case any unexpected issue is detected.

[Stage Direction: Stop the green service to simulate a production fault.]

We will now introduce a controlled failure that represents a serious application problem. This allows us to verify that the protection mechanisms respond automatically.

[Stage Direction: Monitor detects failure and performs automatic rollback.]

The system detected the problem and restored the previous version without requiring manual intervention. Service was restored in **5 seconds**, significantly faster than a person could have responded.

[Stage Direction: Show the health endpoint returning version v1.3.0.]

The service has returned to the stable version, confirming that customer traffic is protected even when a deployment fails.

[Stage Direction: End demonstration.]

This deployment approach reduces operational risk, minimizes service interruption, and gives the business confidence that software updates can be delivered safely and recovered automatically if necessary.
