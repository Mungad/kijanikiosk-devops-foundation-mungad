# KijaniKiosk Kubernetes Deployment

All resources in this directory target the `kijani-project` namespace.

## Payments Secret

The `kk-payments` Deployment requires the following Kubernetes Secret:

- Secret name: `kk-payments-secrets`
- Namespace: `kijani-project`

Expected keys:

- `DB_PASSWORD`
- `STRIPE_API_KEY`
- `JWT_SECRET`

The Secret values are intentionally not committed to Git.

If the cluster is deleted and recreated, obtain the current values from the team and recreate the Secret before applying the deployment.

Example:

```bash
kubectl create secret generic kk-payments-secrets \
  --from-literal=DB_PASSWORD=<value> \
  --from-literal=STRIPE_API_KEY=<value> \
  --from-literal=JWT_SECRET=<value> \
  -n kijani-project
