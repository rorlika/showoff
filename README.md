#### Install dependencies
```
bundle install
```
#### Run tests
```
rspec
```
#### Run server
```
rails server
```
## Requirements 
* rails version >= 5.2
* ruby version >=  2.5.1

## Project Structure

This project follows Rails MVC architecture.

- `app/controllers` - HTTP request handling
- `app/models` - domain models
- `app/services/showoff` - service layer for external/API/business operations
- `app/views` - server-rendered views (where applicable)
- `config/routes.rb` - route definitions

## Routes Overview

From `config/routes.rb`:

- Root: `GET /` -> `widgets#index`
- Widgets:
  - `POST /widgets` -> `widgets#create`
  - `GET /widgets` -> `widgets#index`
  - `POST /widgets/search` -> `widgets#search`
- User widgets:
  - `POST /user_widgets` -> `user_widgets#create`
  - `GET /user_widgets/index_me` -> `user_widgets#index_me`
- User session scope:
  - `GET /users/login` -> `sessions#new`
  - `POST /users/login` -> `sessions#create`
  - `GET /users/logout` -> `sessions#destroy`
- Users:
  - `POST /users` -> `users#create`
  - `GET /users/:id` -> `users#show`
  - `POST /users/reset_password` -> `users#reset_password`

## Controller Refactor Convention

A reusable controller pattern has been established for user-related endpoints and future controller refactors:

1. **Service initialization in `before_action`**
   - Keep actions small and focused.
2. **Strong parameters**
   - Whitelist request attributes in private param methods.
3. **Centralized service-result rendering in `ApplicationController`**
   - Standardize JSON success/error responses.
4. **Consistent JSON response shape**
   - Improve API predictability for clients.

## Documentation

- Users API: `docs/api/users.md`
- ADRs:
  - `docs/adr/0001-centralized-service-result-rendering.md`
  - `docs/adr/0002-users-controller-reusable-pattern.md`
- Tutorial:
  - `docs/tutorials/controller-refactor-pattern.md`
