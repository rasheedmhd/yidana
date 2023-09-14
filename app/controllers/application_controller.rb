# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Pagy::Backend

  add_flash_types :success, :warning, :error
end
