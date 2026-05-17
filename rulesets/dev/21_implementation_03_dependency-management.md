# Dependency Management

## Adding Dependencies
- Check your package registry for current versions before adding.
- Verify dependencies are free of known CVEs (use advisories/OWASP/Snyk/etc.).
- Keep dependencies up to date and document why each addition is needed.

## Dependency Updates
- Use simple commit messages for routine updates; structured commits only when an update enables a new feature.
- Run tests (unit + integration as relevant) after updating dependencies.
