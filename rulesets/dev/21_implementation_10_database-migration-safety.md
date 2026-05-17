# Database Migration Safety

These rules apply to any database migration that modifies an existing schema,
regardless of how migrations are expressed (raw SQL, ORM-managed migrations such
as Alembic / Django migrations / Active Record / Ecto / Prisma, or framework
DSLs such as Flyway, Liquibase, Knex, sqlx).

The principle is the same in all cases: **prefer in-place transforms that
preserve data; treat data loss as something the user must explicitly approve.**

---

## Core Principle: ALTER Over DROP+ADD

When changing an existing column or field, prefer the in-place transform that
preserves data. Dropping and recreating destroys production data, and the
intent ("this is a rename") is invisible to the next reader of the migration.

### Renaming Columns / Fields

When a column needs only renaming (same data type, same semantics), use the
schema's rename operation, not drop + add.

| Surface | Preserves data | Destroys data |
|---|---|---|
| Raw SQL | `ALTER TABLE my_table RENAME COLUMN old_name TO new_name;` | `ALTER TABLE my_table DROP COLUMN old_name;` then `ADD COLUMN new_name ...;` |
| ORM migration (e.g., Alembic) | `op.alter_column(... new_column_name=...)` | `op.drop_column(...)` + `op.add_column(...)` |
| ORM migration (e.g., Django) | `RenameField` operation | `RemoveField` + `AddField` |
| ORM migration (e.g., Active Record) | `rename_column :table, :old, :new` | `remove_column` + `add_column` |
| Builder DSL (e.g., Knex) | `table.renameColumn('old', 'new')` | `table.dropColumn('old')` + `table.string('new')` |

**Examples where rename is correct:**

- `recurrence_interval` → `repeat_interval` (same type, same meaning)
- `user_id` → `owner_id` (same UUID, same reference)

The common-language rule: **if the data is the same, use the rename operation
your migration system provides.** Never reach for drop+add as a shortcut.

---

## Type Changes (Incompatible Data)

When changing column type breaks compatibility (e.g., `VARCHAR` → array,
`INTEGER` → UUID, scalar → JSON), the migration cannot be safe without
either a documented data migration or explicit data loss.

1. **HARD STOP.** Do not write the migration silently.
2. Tell the user: "Column X needs type change from Y to Z. This is incompatible.
   Options:"
   - **(a) Data migration**: convert existing data with a `USING` clause / cast
     / function / migration script.
   - **(b) Drop and recreate**: acceptable data loss for development/staging
     only.
   - **(c) Different approach**: keep the old column, add a new one, migrate
     later in two steps.
3. Wait for explicit instruction before writing the migration.

**Examples requiring HARD STOP:**

- Comma-separated string → array (parsing required)
- `VARCHAR` enum → actual ENUM type (must check valid values)
- Nullable → NOT NULL (must handle existing nulls)
- Widening or narrowing FK relationships (affects referential integrity)

---

## Adding Constraints

Adding `NOT NULL`, `CHECK`, or foreign-key constraints to an existing column
can fail at migration time if existing rows violate the new constraint.

1. Check whether existing data satisfies the constraint before writing the
   migration.
2. If uncertain, **HARD STOP** and ask the user:
   - **(a) Add constraint** (fails if data invalid).
   - **(b) Backfill / update data first**, then add the constraint as a second
     step.
   - **(c) Make it a soft validation** (application-level only).

---

## Safe Transforms

These transforms are always safe in production:

- Rename a column / field (same type)
- Add a nullable column
- Add a column with a sensible default
- Set or drop a default value
- Add a comment / description
- Create a new index concurrently (where the engine supports it)

These transforms require caution and case-by-case review:

- Change a column type (may need a `USING` clause / cast; may lock the table)
- Set `NOT NULL` on a column (must validate existing data first)
- Drop a column (irreversible data loss)
- Add a constraint (may fail on existing data)
- Drop or rename a table (irreversible without a backup)

---

## Migration Review Checklist

Before creating any migration that modifies existing schema:

1. ✓ Can this be expressed as a rename instead of drop + add?
2. ✓ Is the data type change compatible or incompatible?
3. ✓ If incompatible, did I HARD STOP and ask the user?
4. ✓ Will existing data satisfy any new constraints?
5. ✓ Is this safe to run in production without data loss?
6. ✓ Was the migration file created with content in one step (never an empty
   file the migration runner could pick up before the SQL/DSL is finalized)?

---

## When in Doubt

If uncertain about data compatibility or migration safety:

- **HARD STOP.**
- Describe the change and the potential risks.
- Ask the user for explicit approval or an alternative approach.
- Never assume data loss is acceptable.

Production databases contain user data that cannot be recreated. Treat schema
changes with extreme caution regardless of which migration tool is in use.
