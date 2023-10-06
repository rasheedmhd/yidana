# frozen_string_literal: true

module Organisations
  class Create < ActiveInteraction::Base
    def to_model
      Organisation.new
    end
  end
end
