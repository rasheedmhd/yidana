# frozen_string_literal: true

# Taken from https://github.com/rails/rails/blob/main/railties/lib/rails/all.rb

# rubocop:disable Style/RedundantBegin

require 'rails'

[
  'active_record/railtie',
  # 'active_storage/engine',
  'action_controller/railtie',
  'action_view/railtie',
  'action_mailer/railtie',
  'active_job/railtie',
  # 'action_cable/engine',
  # 'action_mailbox/engine',
  # 'action_text/engine',
  'rails/test_unit/railtie'
].each do |railtie|
  begin
    require railtie
  rescue LoadError
  end
end
