# frozen_string_literal: true

module Pu
  module UI
    module Builder
      class Form
        include Concerns::InputBuilder

        attr_reader :record

        def initialize(model_class)
          super(model_class)
        end

        def with_record(record)
          @record = record
          self
        end
      end
    end
  end
end
