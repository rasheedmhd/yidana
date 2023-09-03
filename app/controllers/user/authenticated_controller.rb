# frozen_string_literal: true

class AuthenticatedController < BaseController
  before_action :authenticate
end
