# frozen_string_literal: true

module Pu
  module Helpers
    module DisplayHelper
      def display_field(value:, display_helper: nil, title: nil, options: {})
        stack = options.key?(:stack) ? options[:stack] : display_helper != :display_name_of
        if value.respond_to?(:each) && stack
          tag.ul class: 'list-unstyled' do
            value.each do |val|
              rendered = display_field_value(value: val, display_helper:, title:)
              concat tag.li(rendered)
            end
          end
        else
          rendered = display_field_value(value:, display_helper:, title:)
          tag.span rendered
        end
      end

      def display_field_value(value:, display_helper: nil, title: nil)
        title =  title != false ? title || value : nil
        rendered = display_helper.present? ? send(display_helper, value) : value
        tag.span rendered, title:
      end

      def display_boolean(value)
        tag.input type: :checkbox, class: 'form-check-input', checked: value
      end

      def display_external_url(value)
        link_to nil, value, class: 'text-decoration-none', target: :blank
      end

      def display_name_of(obj, separator = ', ')
        return unless obj.present?

        # If this is an array, display for each
        return obj.map { |i| display_name_of i }.join(separator) if obj.is_a? Array

        # Fallback to retrieving the value from a predefined list
        name_method = nil
        %i[display_name name title].each do |method|
          return obj.send method if obj.respond_to? method
        end

        # Maybe this is a record?
        return "#{resource_name(obj.class)} ##{obj.id}" if obj.respond_to? :id

        # Oh well. Just convert it to a string.
        obj.to_s
      end

      def display_clamped_quill(value)
        clamp quill(value)
      end
    end
  end
end
