# frozen_string_literal: true

module Pu
  module Helpers
    module TurboHelper
      def current_turbo_frame
        request.headers['Turbo-Frame']
      end

      def modal_frame_tag
        return if /custom_action/.match?(controller.action_name)

        turbo_frame_tag 'modal'
      end
    end
  end
end
