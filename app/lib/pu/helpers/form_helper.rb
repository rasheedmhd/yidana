# frozen_string_literal: true

module Pu
  module Helpers
    module FormHelper
      include ActionView::Helpers::FormHelper

      alias pu_overridden_form_for form_for

      #
      # Override the original form_for helper to disable turbo forms by default if not
      # explicitly opted into
      #
      def form_for(record, options = {}, &block)
        options = {
          html: {
            data: {
              turbo_frame: '_top'
            }
          }
        }.deep_merge! options

        pu_overridden_form_for(record, options, &block)
      end
    end
  end
end
