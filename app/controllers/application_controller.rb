# frozen_string_literal: true

class ApplicationController < ActionController::Base
  private

  def current_user
    rodauth(:user).rails_account
  end
  helper_method :current_user
end
