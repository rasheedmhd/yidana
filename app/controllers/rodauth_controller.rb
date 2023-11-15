# frozen_string_literal: true

class RodauthController < ApplicationController
  layout :rodauth_layout
  # common shared controller among various rodauth plugins

  private

  def rodauth_layout
    case request.path
    when rodauth(:user).logout_path
      nil
    # when rodauth.login_path,
    #      rodauth.create_account_path,
    #      rodauth.verify_account_path,
    #      rodauth.verify_account_resend_path,
    #      rodauth.reset_password_path,
    #      rodauth.reset_password_request_path
    #   "authentication"
    else
      'auth'
    end
  end
end
