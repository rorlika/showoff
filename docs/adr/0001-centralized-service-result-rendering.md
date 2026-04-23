# ADR 0001: Centralized Service Result Rendering in ApplicationController

- **Status:** Accepted
- **Date:** 2026-04-23

## Context

Controllers were at risk of duplicating response rendering logic across actions and resources. As more service objects are introduced, repetitive `if success ... else ...` blocks in each controller action reduce consistency and increase maintenance cost.

## Decision

Introduce a centralized rendering helper in `ApplicationController` to render service results in a consistent JSON format and status handling strategy.

## Consequences

### Positive

- Consistent API response structure across controllers
- Less controller boilerplate
- Easier future refactors for additional controllers
- Single place to evolve response policy

### Trade-offs

- Requires service objects to return a compatible result shape
- Controllers must follow the pattern to get full benefit

## Scope

This decision is currently applied to user controller refactor work and is intended as a default convention for future controller updates.
