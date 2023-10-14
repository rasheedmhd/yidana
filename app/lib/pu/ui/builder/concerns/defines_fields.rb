# frozen_string_literal: true

module Pu
  module UI
    module Builder
      module Concerns
        module DefinesFields
          def self.included(base)
            base.send :attr_reader, :model_class
          end

          def initialize(model_class)
            @model_class = model_class
            @enabled_fields = {} # using hash since keys act as an ordered set
            @field_definitions = {}
          end

          def with_fields(*names)
            names.flatten.each do |name|
              define_field(Pu::UI::Field.from_model_field(model_class, name)) unless field_defined?(name)
              @enabled_fields[name] = true
            end
            self
          end

          def define_field(definition)
            @field_definitions[definition.name] = definition
            self
          end

          def only_fields!(*fields)
            @enabled_fields.slice!(*fields.flatten)
            self
          end

          def except_fields!(*fields)
            @enabled_fields.except!(*fields.flatten)
            self
          end

          def fields
            @field_definitions.slice(*@enabled_fields.keys)
          end

          def field?(name)
            @enabled_fields.key? name.to_sym
          end

          def field_defined?(name)
            @field_definitions.key? name.to_sym
          end
        end
      end
    end
  end
end
