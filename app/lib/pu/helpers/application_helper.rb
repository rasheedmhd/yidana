# frozen_string_literal: true

module Pu
  module Helpers
    module ApplicationHelper
      # def tooltip(text)
      #   text = sanitize text
      #   "title=\"#{text}\" data-controller=\"tooltip\" data-bs-title=\"#{text}\"".html_safe
      # end

      def page_title(title)
        [title.presence, Rails.application.class.module_parent.name].compact.join(' | ')
      end

      def display_name_of(obj, separator = ', ')
        return unless obj.present?

        # If this is an array, display for each
        return obj.map { |i| display_name_of i }.join(separator) if obj.is_a? Array

        # Fallback to retrieving the value from a predefined list
        name_method = nil
        %i[display_name name].each do |method|
          return obj.send method if obj.respond_to? method
        end

        # Maybe this is a record?
        return "#{obj.class} #{obj.id}" if obj.respond_to? :id

        # Oh well. Just convert it to a string.
        obj.to_s
      end

      def resource_name(resource_class, count = 1)
        resource_class.to_s.demodulize.pluralize(count).titleize
      end

      def resource_name_plural(resource_class)
        resource_name resource_class, 2
      end

      def attribute_name(_resource_class, name)
        name.to_s.titleize
      end
    end
  end
end
