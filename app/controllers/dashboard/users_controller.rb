# frozen_string_literal: true

module Dashboard
  class UsersController < BaseController
    def index
      @users = current_entity.users
    end
  end
end
