# frozen_string_literal: true

module Pu
  module UI
    module Builder
      class Detail
        include Concerns::FieldBuilder

        attr_reader :record, :actions

        delegate :to_partial_path, to: :record

        def with_record(record)
          @record = record
          self
        end

        def with_actions(actions)
          @actions = actions
          self
        end
      end
    end
  end
end
