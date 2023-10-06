# frozen_string_literal: true

module Organisations
  class Update < ActiveInteraction::Base
    object :organisation

    def to_model
      organisation
    end
  end
end
