# frozen_string_literal: true

# Be sure to restart your server when you modify this file.

return unless Rails.env.development?

Rails.application.configure do
  config.after_initialize do
    Bullet.enable        = true
    Bullet.bullet_logger = true
    Bullet.console       = true
    Bullet.rails_logger  = true
    Bullet.add_footer    = true
    Bullet.alert         = true
    # We want to raise because of hotwire. Else, we miss any alerts unless we manually reload the page.
    Bullet.raise         = true
    # All eager-loaded associations are intentional.
    # Due to how our policy scopes are written, sometimes, they will not be used.
    # It is less dangerous to have unused eager loading than if they are required and absent.
    Bullet.unused_eager_loading_enable = false
  end
end
