# React Mount Mutations

For React applications, mutating requests must not run on component mount.

## Rule
- Do not trigger `POST`, `PATCH`, `PUT`, or `DELETE` requests from `useEffect` or other
  mount-time logic by default.
- Mount logic may perform synchronous capability checks and idempotent reads.
- User-visible commands must start from an explicit user action unless there is a
  documented, strongly justified exception.

## Why
- React StrictMode intentionally re-runs mount logic in development.
- Mount-triggered mutations can therefore execute twice, causing duplicate commands,
  duplicate session writes, and confusing failures.
- Even outside StrictMode, mount-time mutations are harder to reason about than
  user-triggered commands.

## Exception Handling
- If an automatic mutation is truly required, document why it must happen automatically.
- The mutation must be demonstrably idempotent or otherwise protected against duplicate
  execution.
- The code review should call out the exception explicitly rather than treating it as a
  normal pattern.

## Preferred Pattern
- On mount: determine capability, session state, or display state.
- On user action: begin the command or mutation.
- On completion: update local UI state from the result.
