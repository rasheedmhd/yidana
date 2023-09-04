# frozen_string_literal: true

module Users
  class BaseController < ApplicationController
    layout 'users'
    before_action :authenticate

    private

    def authenticate
      # redirect to login page if not authenticated
      rodauth(:user).require_account
    end

    def current_user
      rodauth(:user).rails_account
    end
    helper_method :current_user
  end
end
