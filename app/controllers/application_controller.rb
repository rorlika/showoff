class ApplicationController < ActionController::Base
  # NOTE FOR CONTRIBUTORS:
  # This base controller is the correct place for shared controller behavior,
  # including centralized rendering helpers for service results.
  #
  # Refactor convention:
  # - Controllers delegate business logic to services.
  # - Services return a normalized result.
  # - Controllers render through shared helpers defined here.
end
