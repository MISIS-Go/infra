# k3s Notes

- The chart lives in `infra/helm/bezum`
- Routing is path-based: `/` -> frontend, `/api` + `/ws` -> backend
- The remaining services stay `ClusterIP` and are intended to be internal
- Before deploying, replace `ghcr.io/your-org/bezum/*` and set real flags/secrets via values or Kubernetes Secret
