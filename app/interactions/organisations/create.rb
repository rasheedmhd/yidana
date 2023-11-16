# frozen_string_literal: true

module houses
  class Create < ActiveInteraction::Base
    def to_model
      House.new
    end
  end
end
