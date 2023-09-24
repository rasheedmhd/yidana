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
          name = name.to_sym
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
        @inputs.slice!(*inputs.flatten.map(&:to_sym))
        self
      end

      def except!(*inputs)
        @inputs.except!(*inputs.flatten.map(&:to_sym))
        self
      end

      def input_names
        inputs.values.pluck(:label)
      end

      def inputs
        @definitions.slice(*@inputs.keys)
      end

      def input?(name)
        @inputs.key? name.to_sym
      end

      def input_defined?(name)
        @definitions.key? name.to_sym
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
            input_html: { multiple: }
          }

          if multiple
            placeholder = options[:placeholder] || "Select #{name.to_s.humanize(capitalize: false).pluralize}"
            definition.deep_merge! input_html: {
              data: {
                slim_select_placeholder_value: placeholder,
                slim_select_close_on_select_value: false
              }
            }
          else
            placeholder = options[:placeholder] || "Select #{name.to_s.humanize(capitalize: false)}"
            definition.deep_merge! include_blank: placeholder,
                                   input_html: {
                                     data: { slim_select_allow_deselect_value: true }
                                   }
          end
        when :quill
          definition = { wrapper: :quill }
        end

        definition.deep_merge options
      end
    end
  end
end
