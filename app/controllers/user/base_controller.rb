# frozen_string_literal: true

class BaseController < ApplicationController
  private

  def authenticate
    rodauth(:user).require_account # redirect to login page if not authenticated
  end
end
