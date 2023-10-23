# frozen_string_literal: true

module Pu
  module UI
    class Field
      attr_reader :name, :label, :helper, :options

      def initialize(name, **options)
        @name = name
        @label = options.delete :label
        @helper = options.delete :helper
        @options = options
      end

      def label
        @label ||= name.to_s.titleize(keep_id_suffix: true)
      end

      def self.build(name, type:, **options)
        options[:helper] ||= case type
                             when :string, :text, :citext
                               :display_url_value if name.ends_with? '_url'
                             when :integer, :float, :decimal
                               :display_numeric_value
                             when :datetime, :timestamp, :time, :date
                               :timeago
                             when :boolean
                               :display_boolean_value
                             when :association
                               :display_association_value
                             when :attachment
                               :display_attachment_value
                             end

        # binary:      { name: "blob" },
        # blob:        { name: "blob" },
        # json:        { name: "json" },

        options[:max_width] ||= 400 if %i[string text citext].include? type
        options[:max_width] ||= 250

        new name, **options
      end

      def self.for_attribute(model_class, name, type: nil, **options)
        column = model_class.column_for_attribute name if model_class.respond_to? :column_for_attribute
        attachment = model_class.reflect_on_attachment name if model_class.respond_to? :reflect_on_attachment
        association = model_class.reflect_on_association name if model_class.respond_to? :reflect_on_association

        if attachment.present?
          type ||= :attachment
          options[:stack] = false if options[:stack].nil?
        elsif association.present?
          type ||= :association if %i[belongs_to has_one].include? association.macro
        elsif column.present?
          type ||= column.type
          options[:stack] = column.array? if options[:stack].nil? && column.respond_to?(:array?)
        end

        build name, type:, **options
      end
    end
  end
end
