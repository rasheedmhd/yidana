# frozen_string_literal: true

class ApplicationController < ActionController::Base
  add_flash_types :success, :warning

  private

  def current_user
    rodauth(:user).rails_account
  end
  helper_method :current_user
end
