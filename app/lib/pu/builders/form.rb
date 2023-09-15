# frozen_string_literal: true

module Pu
  module Builders
    class Form
      include ActionView::Helpers::TagHelper

      attr_reader :model, :record, :inputs, :definitions

      def initialize(model)
        @model = model
        @inputs = {} # using hash since keys act as an ordered set
        @definitions = {}
      end

      def with_record(record)
        @record = record
        self
      end

      def with_inputs(*names)
        names.flatten.each do |name|
          define_input name unless input_defined? name
          @inputs[name] = true
        end
        self
      end

      def define_input(name, type: nil, **options)
        name = name.to_sym
        type ||= model.columns_hash[name.to_s]&.type

        custom_definition = { **options }.compact
        @definitions[name] = build_definition(name, type).deep_merge custom_definition
        self
      end

      def only!(*inputs)
        @inputs.slice!(*inputs.flatten)
        self
      end

      def except!(*inputs)
        @inputs.except!(*inputs.flatten)
        self
      end

      def input_names
        inputs.values.pluck(:label)
      end

      def inputs
        @definitions.slice(*@inputs.keys)
      end

      def input?(name)
        @inputs.key? name
      end

      def input_defined?(name)
        @definitions.key? name
      end

      protected

      def build_definition(_name, type)
        options = {}

        case type
        when :string, :text, :citext
          options[:input_html] = { data: { controller: 'textarea-autogrow' } }
        end

        options
      end
    end
  end
end
