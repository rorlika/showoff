# Tutorial: Applying the Reusable Controller Refactor Pattern

This tutorial explains how to apply the same pattern used for `UsersController` to other controllers.

## Goal

Create thin controllers with:
- service setup in `before_action`
- strong params
- centralized JSON rendering through `ApplicationController`

## Step 1: Define/Reuse a Service

Use or create a service in `app/services/showoff`, for example:
- `showoff/user_service.rb`
- `showoff/widget_service.rb`

Service methods should return a predictable result object/hash (success, data/errors, status).

## Step 2: Initialize Service in Controller

In controller:

- add `before_action :set_service`
- define `set_service` private method

This keeps each action focused on one call + one render.

## Step 3: Add Strong Params

For each mutating action, add a private params method, for example:
- `create_params`
- `update_params`
- `search_params`

Never pass raw `params` directly into services.

## Step 4: Delegate and Render Centrally

Action pattern:
1. call service method with validated params
2. pass result to centralized renderer in `ApplicationController`

This avoids custom render branches in every action.

## Step 5: Keep Response Shape Consistent

Ensure success and error payloads follow the same envelope across resources.

## Example Flow (Users)

- `POST /users`
  - controller validates params
  - delegates to user service create method
  - renders via centralized renderer

- `GET /users/:id`
  - controller passes id to service
  - renders via centralized renderer

- `POST /users/reset_password`
  - controller validates payload
  - delegates reset action to service
  - renders via centralized renderer

## Validation Checklist

- [ ] `before_action` service setup present
- [ ] strong params present for input actions
- [ ] no business logic in controller actions
- [ ] centralized renderer used for JSON responses
- [ ] route behavior unchanged unless intentionally updated
