# frozen_string_literal: true

module Rodauth
  class UserController < RodauthController
    # used by Rodauth for rendering views, CSRF protection, and running any
    # registered action callbacks and rescue_from handlers
  end
end
