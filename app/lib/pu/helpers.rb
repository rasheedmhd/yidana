# frozen_string_literal: true

module Pu
  module Helpers
    def self.included(base)
      base.class_eval do
        include Pu::Helpers::ApplicationHelper
        include Pu::Helpers::AccessHelper
        include Pu::Helpers::ButtonsHelper
        include Pu::Helpers::ContentHelper
        include Pu::Helpers::FormHelper
        include Pu::Helpers::MenuHelper
        include Pu::Helpers::PaginationHelper
      end
    end
  end
end
