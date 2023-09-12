# frozen_string_literal: true

module FormHelper
  include ActionView::Helpers::FormHelper

  alias rails_default_form_for form_for

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

    rails_default_form_for(record, options, &block)
  end
end
