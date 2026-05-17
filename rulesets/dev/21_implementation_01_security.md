# Security

## Secret Handling — Critical
- NEVER capture sensitive data in terminal output or read secret files into AI context.
- Secrets must not appear in terminal output, file read operations, variables, strings, or anywhere they would enter model context/logs.

Always handle secrets through pipes:
- Allowed: `flyctl tokens create deploy | gh secret set TOKEN_NAME`
- Allowed: `cat .env.production.secrets | grep PASSWORD | sed 's/old/new/' | tee .env.production.secrets`
- Allowed: `echo "NEW_SECRET=value" | tee -a .env.production.secrets`
- Do not: assign secrets to variables and echo them (e.g., `TOKEN=$(flyctl tokens create)` then `echo $TOKEN | gh secret set ...`).
- Do not: read `.env.production.secrets` into model context.

When secrets must be stored or modified:
- Use pipes so values stay in shell memory only.
- Prefer temporary files in `/tmp` that never get read back into the model context.
- Use shell redirects (`>>`, `tee`) without capturing output.
- Example: `command-that-outputs-secret | command-that-consumes-secret`.

Security rationale:
- Terminal output and file reads expose secrets in AI context and logs.
- Pipes prevent accidental leaks during debugging or in conversation history.

## Command Injection Prevention
- NEVER use backticks in shell commands.
- Quote variables properly (use `"$VAR"`).
- Validate or sanitize any user-provided input before using it in shell commands.
- Prefer tool parameters instead of shell interpolation when possible.
- **NEVER use inline strings with special shell characters** (`!`, `$`, `` ` ``, `\`, `"`, `'`, `*`, `?`, `[`, `]`, `{`, `}`, `(`, `)`, `<`, `>`, `|`, `&`, `;`, `#`) in command arguments.
- **Always use temporary files for complex or multi-line text** (commit messages, config files, scripts).
- For git commits: use `git commit -F <tempfile>` instead of `git commit -m "..."`.

**Rationale**: Shell interpreters (bash, zsh, etc.) treat many characters specially (history expansion, variable substitution, globbing, command substitution). Using temporary files avoids all shell parsing issues and buffer limits.

## Temporary Files — Safe Patterns

**CRITICAL: Always use `mktemp` or date-based unique names to avoid file-exists errors.**

### Always Use mktemp (Recommended)

```bash
# GOOD: Safe, unique temp file (standard approach)
TEMP_FILE=$(mktemp)
cat >| "$TEMP_FILE" << 'EOF'
content
EOF
process_file "$TEMP_FILE"
rm "$TEMP_FILE"

# GOOD: Temp file with custom template
TEMP_FILE=$(mktemp /tmp/spring-boot.XXXXXX.log)
./mvnw spring-boot:run > "$TEMP_FILE" 2>&1 &

# GOOD: Temp directory
TEMP_DIR=$(mktemp -d /tmp/build.XXXXXX)
```

### Alternative: Date-Based Unique Names

```bash
# GOOD: Timestamp-based unique filename
TEMP_FILE="/tmp/commit-msg-$(date +%Y%m%d-%H%M%S-%N).txt"
cat >| "$TEMP_FILE" << 'EOF'
Commit message content
EOF

# GOOD: Process ID + timestamp
TEMP_FILE="/tmp/build-$$-$(date +%s).log"
```

### Shell Compatibility: zsh

**When writing to temp files in zsh:**

```bash
# GOOD: Use >| to force overwrite (zsh-safe)
MSGFILE=$(mktemp)
cat >| "$MSGFILE" << 'EOF'
content
EOF
git commit -F "$MSGFILE"
rm "$MSGFILE"

# GOOD: Use > with unique mktemp file (no conflicts possible)
TEMP_FILE=$(mktemp)
cat > "$TEMP_FILE" << 'EOF'
content
EOF

# BAD: Plain > fails in zsh if file exists (noclobber is default)
cat > /tmp/fixed-name.txt << 'EOF'  # ERROR in zsh
content
EOF
```

**Why:** zsh has `noclobber` enabled by default, preventing `>` from overwriting existing files. Use `>|` to force overwrite, or better: use `mktemp` to guarantee unique filenames.

### Git Commit Messages Example

```bash
# GOOD: Safe commit message handling with retry-friendly cleanup
MSGFILE=$(mktemp)
cat >| "$MSGFILE" << 'EOF'
✨ Your commit message

## Summary
...
EOF

# Run the repo hook/pre-check first when the repo exposes one
# If the commit fails, keep $MSGFILE for the retry
git commit -F "$MSGFILE"

# Verify the commit before cleanup
echo "HEAD=$(git rev-parse --short HEAD)" && git --no-pager show HEAD --stat --format="commit %H%nDate: %ai%nSubject: %s" | cat

unlink "$MSGFILE"
```

### Never Do This

```bash
# BAD: Hardcoded name causes conflicts
./mvnw spring-boot:run > /tmp/spring-boot.log 2>&1 &

# BAD: Fails if file exists (especially in zsh)
cat > /tmp/commit-msg.txt << EOF
...
EOF

# BAD: Reusing same temp file in multiple commands
cat > /tmp/msg.txt << EOF
first message
EOF
git commit -F /tmp/msg.txt
cat > /tmp/msg.txt << EOF  # May fail!
second message
EOF
```

### Cleanup

```bash
# GOOD: Remove temp file when done (unlink is safer than rm: single file only, no dirs, no globs)
unlink "$TEMP_FILE"

# GOOD: Auto-cleanup with trap
trap "unlink $TEMP_FILE" EXIT
```
