# frozen_string_literal: true

module Dashboard
  class BaseController < ApplicationController
    include CurrentEntity

    layout 'dashboard'
  end
end
