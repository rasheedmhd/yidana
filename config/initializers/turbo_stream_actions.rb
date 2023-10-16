# frozen_string_literal: true

# Be sure to restart your server when you modify this file.

Rails.application.configure do
  config.after_initialize do
    # Add Turbo Steam Actions
    Turbo::Streams::TagBuilder.prepend(Pu::Helpers::TurboStreamActionsHelper)
  end
end
