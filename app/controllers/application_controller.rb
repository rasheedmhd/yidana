# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Pagy::Backend

  add_flash_types :success, :warning

  private

  def app_name
    Rails.application.class.module_parent.name
  end
  helper_method :app_name
end
