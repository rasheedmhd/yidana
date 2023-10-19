# frozen_string_literal: true

module Pu
  module UI
    class Input
      attr_reader :name, :options

      def initialize(name, **options)
        @name = name
        @options = options
      end

      def self.build(name, type:, **options)
        multiple = options[:multiple]

        definition = {}
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

        options = definition.deep_merge options

        new name, **options
      end

      def self.for_attribute(model_class, name, type: nil, **options)
        column = model_class.column_for_attribute name

        type ||= :slim_select if options.key? :collection
        type ||= column.type
        options[:multiple] ||= column.array? if column.respond_to? :array?

        build name, type:, **options
      end
    end
  end
end
