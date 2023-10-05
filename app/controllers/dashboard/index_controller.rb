# frozen_string_literal: true

module Dashboard
  class IndexController < BaseController
    skip_after_action :verify_authorized
    skip_after_action :verify_policy_scoped

    def index; end
  end
end
