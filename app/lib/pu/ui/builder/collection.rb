# frozen_string_literal: true

module Pu
  module UI
    module Builder
      class Collection
        include Concerns::FieldBuilder

        attr_reader :records, :actions, :record_actions, :pagination, :search_object, :search_field

        def initialize(model_class)
          super(model_class)

          @records = []
        end

        def with_records(records)
          @records = records
          self
        end

        def with_actions(actions)
          @actions = actions
          self
        end

        def with_record_actions(record_actions)
          @record_actions = record_actions
          self
        end

        def with_pagination(pagination)
          @pagination = pagination
          self
        end

        def search_with(object, field)
          @search_object = object
          @search_field = field
          self
        end
      end
    end
  end
end
