# frozen_string_literal: true

module Pu
  module Builders
    class Table
      include ActionView::Helpers::NumberHelper
      include Pu::Helpers::ContentHelper
      include ActionView::Helpers::TagHelper

      attr_reader :model, :records, :pagination, :record_actions, :toolbar_actions, :search_object, :search_field

      def initialize(model)
        @model = model
        @records = []
        @columns = {} # using hash since keys act as an ordered set
        @definitions = {}
      end

      def with_records(records)
        @records = records
        self
      end

      def with_pagination(pagination)
        @pagination = pagination
        self
      end

      def with_record_actions(record_actions)
        @record_actions = record_actions
        self
      end

      def with_toolbar_actions(toolbar_actions)
        @toolbar_actions = toolbar_actions
        self
      end

      def search_with(object, field)
        @search_object = object
        @search_field = field
        self
      end

      def with_columns(*names)
        names.flatten.each do |name|
          name = name.to_sym
          define_column name unless column_defined? name
          @columns[name] = true
        end
        self
      end

      def define_column(name, type: nil, label: nil, display_helper: nil, options: {})
        name = name.to_sym
        column = model.columns_hash[name.to_s]
        type ||= column&.type

        custom_definition = { label:, display_helper:, options: }.compact
        @definitions[name] = build_definition(name, type, column).deep_merge custom_definition
        self
      end

      def only!(*columns)
        @columns.slice!(*columns.flatten.map(&:to_sym))
        self
      end

      def except!(*columns)
        @columns.except!(*columns.flatten.map(&:to_sym))
        self
      end

      def column_names
        columns.values.pluck(:label)
      end

      def columns
        @definitions.slice(*@columns.keys)
      end

      def column?(name)
        @columns.key? name.to_sym
      end

      def column_defined?(name)
        @definitions.key? name.to_sym
      end

      protected

      def build_definition(name, type, column)
        options = {
          max_width: 250,
          stack: column&.array?
        }

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
        display_helper = :display_association if %i[belongs_to
                                                    has_one].include?(model.reflect_on_association(name)&.macro)

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
