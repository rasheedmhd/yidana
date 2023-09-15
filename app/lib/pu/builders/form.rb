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
        @definitions[name] = build_definition(name, type, options)
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

      def build_definition(name, type, options = {})
        return options if options[:as].present?

        definition = {}
        column = model.columns_hash[name.to_s]

        type ||= :slim_select if options.key? :collection
        type ||= column&.type
        multiple = column&.array?

        case type
        when :string, :text, :citext
          definition = {
            input_html: {
              data: { controller: 'textarea-autogrow' }
            }
          }
        when :slim_select
          definition = {
            wrapper: :slim_select,
            input_html: {
              data: { controller: 'slim-select' },
              multiple:
            }
          }

          if multiple
            definition[:input_html][:data][:slim_select_placeholder_value] =
              "Select #{name.to_s.humanize(capitalize: false).pluralize}"
          else
            definition.deep_merge! include_blank: "Select #{name.to_s.humanize(capitalize: false)}",
                                   input_html: {
                                     data: { slim_select_allow_deselect_value: true }
                                   }
          end
        end

        definition.deep_merge options
      end
    end
  end
end
