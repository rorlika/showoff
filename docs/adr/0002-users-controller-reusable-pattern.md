# ADR 0002: UsersController Refactor to Reusable Controller Pattern

- **Status:** Accepted
- **Date:** 2026-04-23

## Context

The project requires a scalable controller pattern that can be reused for other resources. Users endpoints are a good first target because they include create/show/reset-password behaviors and interact with service objects.

## Decision

Refactor `UsersController` to follow a reusable pattern:

1. Initialize required service objects via `before_action`
2. Use strong params for request whitelisting
3. Delegate business logic to service layer
4. Render service outcomes through centralized `ApplicationController` helper
5. Return consistent JSON responses

## Consequences

### Positive

- Clear separation of concerns
- Smaller controller actions
- Reusable pattern for widgets, sessions, and other future controllers
- Better API consistency for clients

### Trade-offs

- Initial refactor effort to align existing controllers
- Team must follow the convention for consistency

## Follow-up

Apply the same pattern incrementally to other controllers (`WidgetsController`, `UserWidgetsController`, `SessionsController`) where applicable.
