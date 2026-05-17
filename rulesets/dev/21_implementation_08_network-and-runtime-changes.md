# Network And Runtime Changes

Treat network, container, deployment, and runtime-environment changes as
cross-cutting changes.

When changing ports, hostnames, service names, protocols, container users,
healthchecks, CORS origins, environment variables, or compose/deployment wiring:

- scan the repository for dependent references in code, scripts, docs, tests,
  QA/staging config, and manual runbooks,
- update durable documentation and run/test instructions that would mislead users,
- validate the affected runtime path, not just compilation,
- rerun relevant e2e/manual-equivalent checks when QA, staging, or test service
  wiring changes,
- preserve secure defaults such as non-root containers and least-privilege network
  exposure.

Do not treat these as isolated file edits. Confirm the system still runs the way
the docs and scripts say it runs.
