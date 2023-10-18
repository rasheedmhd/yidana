# frozen_string_literal: true

module Pu
  module Helpers
    module TurboStreamActionsHelper
      def redirect(url)
        turbo_stream_action_tag :redirect, url:
      end
    end
  end
end
