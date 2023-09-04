# frozen_string_literal: true

module Rodauth
  class BaseController < ApplicationController
    layout 'rodauth'

    # common shared controller among various rodauth plugins
  end
end
