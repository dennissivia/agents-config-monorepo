# Environment Safety

These rules ensure safe interaction with databases, processes, and services
during development and QA work.

---

## Database Safety — Critical

**Never destroy data without explicit confirmation.**

### Data Classification

- **Test containers**: Throw-away data, can be reset freely during test runs.
- **Dev / staging databases**: Custom data, treat as valuable.
- **Production**: Never touch directly.

### Prohibited Without Confirmation

- Dropping databases.
- Dropping tables (including migration metadata such as Flyway / Liquibase /
  Alembic / Django version tables).
- Deleting rows with `DELETE` statements.
- Truncating tables.
- Resetting sequences or migration history.

### When Database Issues Arise

1. **Describe the problem.** What is wrong? What did you observe?
2. **Propose options.** List 2-3 potential solutions with trade-offs.
3. **Ask for the decision.** Let the user choose the approach.
4. **Document reasoning.** Explain why the chosen solution makes sense.

**Example (good):**

```
I see the migration metadata shows version X but migration files contain
version Y. This usually means:
- container image is stale (built before new migrations)
- volume persisted old metadata

Options:
a) Rebuild the container image to include new migrations
b) Clear migration metadata tables (loses migration history)
c) Drop and recreate the database (loses all data)

Which approach would you prefer?
```

**Never do this:**

```bash
# BAD: Drops tables without asking
docker exec postgres psql -c "DROP TABLE flyway_schema_history CASCADE;"
```

---

## Process Management

Use professional process-handling techniques.

### Starting Background Processes

Always store the PID for safe management:

```bash
# GOOD: store PID for clean shutdown later
cd /path/to/app
./run-server > /tmp/server.log 2>&1 &
echo $! > /tmp/server.pid
```

```bash
# BAD: no way to track or stop cleanly
nohup ./run-server > /tmp/log 2>&1 &
```

### Before Starting Processes

Check if already running:

```bash
if [ -f /tmp/server.pid ]; then
    PID=$(cat /tmp/server.pid)
    if ps -p "$PID" > /dev/null 2>&1; then
        echo "Server already running (PID: $PID)"
        # decide: restart? leave alone? check health?
    fi
fi
```

### Stopping Processes

1. **Try graceful shutdown first** (SIGTERM):
   ```bash
   if [ -f /tmp/server.pid ]; then
       PID=$(cat /tmp/server.pid)
       if ps -p "$PID" > /dev/null 2>&1; then
           kill "$PID"  # SIGTERM
           sleep 2
           if ps -p "$PID" > /dev/null 2>&1; then
               echo "Process still running, may need SIGKILL"
           fi
       fi
   fi
   ```

2. **Only use SIGKILL if graceful fails.**
3. **Never use `pkill -f pattern`** — too broad, kills unintended processes.

### When Process Issues Arise

Before killing anything:

1. Identify the problem: port conflict, outdated code, hung process?
2. Check process ownership: `ps -p "$PID" -o pid,user,command`
3. Propose action: "Process X appears hung because Y. Kill and restart?"
4. Wait for confirmation.

---

## Container Management

### Before Starting Containers

Always check whether containers are already running:

```bash
docker compose ps servicename
# or
if [ "$(docker ps -q -f name=container-name)" ]; then
    echo "Container already running"
fi
```

### Starting Containers

```bash
# GOOD: only start what's needed
docker compose up -d postgres adminer --wait

# Confirm health before proceeding
docker compose ps postgres | grep "healthy"
```

### Stopping Containers

```bash
# GOOD: graceful stop
docker compose stop servicename

# Only if needed
docker compose down  # removes containers but preserves volumes
```

Avoid:

```bash
# Risky: destroys volumes without asking
docker compose down -v
```

---

## Test Debugging Workflow

Move incrementally from specific to general.

### When A Test Fails

1. **Isolate the failing test** and run only that test method.
2. **Fix and verify** the specific test passes.
3. **Expand scope incrementally**:
   - Run all tests in the same test class / file.
   - Run all tests of the same type (unit / integration).
   - Run the full suite.
4. **Never skip to the full suite** if one test is still failing.

### Benefits

- Faster feedback loop.
- Easier to identify the root cause.
- Avoids masking issues with unrelated test noise.
- Saves time by not running the full suite repeatedly.

---

## Temporary Files

Use safe temporary-file patterns. The full guidance — `mktemp`, date-based
unique names, zsh `>|` overwrite, cleanup with `unlink` or `trap` — lives in
the shared security file (`21_implementation_01_security.md`, "Temporary Files
— Safe Patterns" section). Do not duplicate it here.

Quick reminder:

- Always use `mktemp` or date-based unique names.
- Use `>|` (not `>`) in zsh to force overwrite.
- Never use hardcoded paths like `/tmp/commit-msg.txt`.

---

## Command-Line Best Practices

### Variable Quoting

```bash
# GOOD: handles spaces and special characters
cd "$WORKSPACE_DIR" && ./run-tests

# BAD: breaks with spaces
cd $WORKSPACE_DIR && ./run-tests
```

### Error Handling

```bash
# GOOD: check whether the command succeeded
if docker compose up -d --wait; then
    echo "Containers started successfully"
else
    echo "Failed to start containers"
    exit 1
fi

# GOOD: stop on first error
set -e
```

### Process Checks

```bash
# GOOD: verify process running
if ps -p "$PID" > /dev/null 2>&1; then
    echo "Process $PID is running"
fi

# GOOD: check port availability
if lsof -i :8080 > /dev/null 2>&1; then
    echo "Port 8080 in use"
fi
```

---

## Summary

**Core principles:**

1. Treat dev / staging data as valuable — never destroy without confirmation.
2. Manage processes professionally — store PIDs, check before acting, graceful
   shutdown.
3. Check before starting — containers, processes, ports.
4. Move incrementally — isolate failing tests, expand scope gradually.
5. Use safe patterns — `mktemp`, quote variables, check process existence.
6. Ask before destructive actions — describe problem, propose options, wait
   for the decision.

These practices ensure safe, predictable, and professional development
workflows.
