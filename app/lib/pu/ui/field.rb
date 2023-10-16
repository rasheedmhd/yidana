# frozen_string_literal: true

module Pu
  module UI
    class Field
      attr_reader :name, :label, :display_helper, :options

      def initialize(name, label: nil, display_helper: nil, **options)
        @name = name
        @label = label
        @display_helper = display_helper
        @options = options
      end

      def label
        @label ||= name.to_s.titleize(keep_id_suffix: true)
      end

      def self.for_attribute(model_class, name, label: nil, options: {})
        column = model_class.columns_hash[name.to_s]

        display_helper = nil

        if %i[belongs_to has_one].include?(model_class.reflect_on_association(name)&.macro)
          display_helper = :display_association
        else
          type = column.type
          case type
          when :string, :text, :citext
            options[:max_width] ||= 400
            display_helper = :display_url_value if name.ends_with? '_url'
          when :integer, :float, :decimal
            display_helper = :number_with_delimiter
          when :datetime, :timestamp, :time, :date
            display_helper = :timeago
          when :boolean
            display_helper = :display_boolean_value
          end

          # binary:      { name: "blob" },
          # blob:        { name: "blob" },
          # json:        { name: "json" },
          options[:stack] = column.array? if options[:stack].nil?
        end

        options[:max_width] = 250 if options[:max_width].nil?

        new name, label:, display_helper:, **options
      end
    end
  end
end
