# frozen_string_literal: true

module Pu
  module UI
    module Builder
      module Concerns
        module FieldBuilder
          def self.included(base)
            base.send :attr_reader, :model_class
          end

          def initialize(model_class)
            @model_class = model_class
            @fields = {} # using hash since keys act as an ordered set
            @definitions = {}
          end

          def with_fields(*names)
            names.flatten.each do |name|
              define_field(Pu::UI::Field.from_model_field(model_class, name)) unless field_defined?(name)
              @fields[name] = true
            end
            self
          end

          def define_field(definition)
            @definitions[definition.name] = definition
            self
          end

          def only!(*fields)
            @fields.slice!(*fields.flatten.map(&:to_sym))
            self
          end

          def except!(*fields)
            @fields.except!(*fields.flatten.map(&:to_sym))
            self
          end

          # def field_names
          #   fields.values.pluck(:label)
          # end

          def fields
            @definitions.slice(*@fields.keys)
          end

          def field?(name)
            @fields.key? name.to_sym
          end

          def field_defined?(name)
            @definitions.key? name.to_sym
          end
        end
      end
    end
  end
end
