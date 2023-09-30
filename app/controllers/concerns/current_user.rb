# frozen_string_literal: true

#
# Requires the current user in the :authenticate before action
# Current user is available via #current_user
#
module CurrentUser
  def self.included(base)
    base.send :before_action, :authenticate
    base.send :helper_method, :current_user
  end

  private

  def authenticate
    # redirect to login page if not authenticated
    rodauth(:user).require_account
  end

  def current_user
    rodauth(:user).rails_account
  end
end
