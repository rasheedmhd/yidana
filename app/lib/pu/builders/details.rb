# frozen_string_literal: true

module Pu
  module Builders
    class Details
      include ActionView::Helpers::NumberHelper
      include Pu::Helpers::ContentHelper
      include ActionView::Helpers::TagHelper

      attr_reader :model, :record, :actions, :toolbar_actions

      delegate :to_partial_path, to: :record

      def initialize(model)
        @model = model
        @record = []
        @fields = {} # using hash since keys act as an ordered set
        @definitions = {}
      end

      def with_record(record)
        @record = record
        self
      end

      def with_actions(actions)
        @actions = actions
        self
      end

      def with_fields(*names)
        names.flatten.each do |name|
          name = name.to_sym
          define_field name unless field_defined? name
          @fields[name] = true
        end
        self
      end

      def define_field(name, type: nil, label: nil, display_helper: nil, options: {})
        name = name.to_sym
        type ||= model.columns_hash[name.to_s]&.type

        custom_definition = { label:, display_helper:, options: }.compact
        @definitions[name] = build_definition(name, type).deep_merge custom_definition
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

      def field_names
        fields.values.pluck(:label)
      end

      def fields
        @definitions.slice(*@fields.keys)
      end

      def field?(name)
        @fields.key? name.to_sym
      end

      def field_defined?(name)
        @definitions.key? name.to_sym
      end

      protected

      def build_definition(name, type)
        options = {}

        display_helper = nil
        case type
        when :string, :text, :citext
          options[:max_width] = 400
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

        display_helper = :display_url_value if name.ends_with? '_url'

        {
          name:,
          type:,
          label: name.to_s.titleize(keep_id_suffix: true),
          display_helper:,
          options:
        }
      end
    end
  end
end
