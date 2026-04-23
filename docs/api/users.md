# Users API

This document describes the `users`-related HTTP endpoints currently defined in `config/routes.rb` and implemented by Rails controllers in this project.

## Base Notes

- Framework: Rails 5.2
- Response format: JSON for API-style controller actions (as established by the refactor requirement)
- Routes source: `config/routes.rb`

## Endpoints

### Create User

- **Method:** `POST`
- **Path:** `/users`
- **Controller action:** `UsersController#create`

#### Purpose
Create a new user account.

#### Request
Typical JSON body (actual accepted keys are controlled by strong params in `UsersController`):

```json
{
  "user": {
    "name": "Jane Doe",
    "email": "jane@example.com",
    "password": "secret123"
  }
}
```

#### Response
Expected convention after refactor:
- Success: JSON payload from service result, success HTTP status
- Failure: JSON payload with error details, appropriate error HTTP status

Example success response:

```json
{
  "success": true,
  "data": {
    "id": 123,
    "name": "Jane Doe",
    "email": "jane@example.com"
  }
}
```

Example error response:

```json
{
  "success": false,
  "errors": ["Email has already been taken"]
}
```

---

### Show User

- **Method:** `GET`
- **Path:** `/users/:id`
- **Controller action:** `UsersController#show`

#### Purpose
Return a single user by id.

#### Request
Path param:
- `id` (required)

#### Response
Expected convention after refactor:
- Success: JSON payload for requested user
- Failure: JSON error payload (e.g., not found)

Example success response:

```json
{
  "success": true,
  "data": {
    "id": 123,
    "name": "Jane Doe",
    "email": "jane@example.com"
  }
}
```

Example not found response:

```json
{
  "success": false,
  "errors": ["User not found"]
}
```

---

### Reset Password

- **Method:** `POST`
- **Path:** `/users/reset_password`
- **Controller action:** `UsersController#reset_password`

#### Purpose
Trigger user password reset flow.

#### Request
Typical JSON body (exact keys depend on strong params in controller):

```json
{
  "email": "jane@example.com"
}
```

or

```json
{
  "user": {
    "email": "jane@example.com"
  }
}
```

#### Response
Expected convention after refactor:
- Success: JSON confirmation payload
- Failure: JSON error payload

Example success response:

```json
{
  "success": true,
  "message": "Password reset instructions sent"
}
```

Example error response:

```json
{
  "success": false,
  "errors": ["Email not found"]
}
```

## Authentication-related User Routes

These are user-scoped session routes defined under `scope :users`:

- `GET /users/login` -> `SessionsController#new`
- `POST /users/login` -> `SessionsController#create`
- `GET /users/logout` -> `SessionsController#destroy`

They are documented here for completeness because they are user account lifecycle endpoints.

## Controller Pattern (Refactor Convention)

The refactor introduces a reusable pattern:

1. Service object setup in `before_action`
2. Strong parameter methods per action
3. Centralized rendering of service results in `ApplicationController`
4. Consistent JSON response envelope

This convention should be reused by future controllers to keep behavior and response shape consistent.
