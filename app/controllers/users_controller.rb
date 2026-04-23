class UsersController < ApplicationController
  # NOTE FOR CONTRIBUTORS:
  # UsersController follows the reusable controller refactor pattern:
  # - service setup via before_action
  # - strong params for whitelisting
  # - consistent JSON response rendering through ApplicationController helpers
  #
  # Keep actions thin and delegate business logic to service objects.
end
