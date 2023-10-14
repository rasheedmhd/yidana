# frozen_string_literal: true

module Pu
  module UI
    module Builder
      module Concerns
        module DefinesInputs
          def self.included(base)
            base.send :attr_reader, :model_class
          end

          def initialize(model_class)
            @model_class = model_class
            @enabled_inputs = {} # using hash since keys act as an ordered set
            @input_definitions = {}
          end

          def with_inputs(*names)
            names.flatten.each do |name|
              define_input(Pu::UI::Input.from_model_field(model_class, name)) unless input_defined?(name)
              @enabled_inputs[name] = true
            end
            self
          end

          def define_input(definition)
            @input_definitions[definition.name] = definition
            self
          end

          def only_inputs!(*inputs)
            @enabled_inputs.slice!(*inputs.flatten)
            self
          end

          def except_inputs!(*inputs)
            @enabled_inputs.except!(*inputs.flatten)
            self
          end

          def inputs
            @input_definitions.slice(*@enabled_inputs.keys)
          end

          def input?(name)
            @enabled_inputs.key? name.to_sym
          end

          def input_defined?(name)
            @input_definitions.key? name.to_sym
          end
        end
      end
    end
  end
end
