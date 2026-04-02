# CI

The main workflow lives in `.github/workflows/ci.yml`.

It is responsible for:
- building service Docker images
- pushing them to GHCR on `push`
- running `helm lint` for `infra/helm/bezum`
