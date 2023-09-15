# frozen_string_literal: true

module Pu
  module Builders
    class Table
      include ActionView::Helpers::NumberHelper
      include Pu::Helpers::ContentHelper
      include ActionView::Helpers::TagHelper

      attr_reader :model, :records, :pagination

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

      def with_columns(*names)
        names.flatten.each do |name|
          define_column name unless column_defined? name
          @columns[name] = true
        end
        self
      end

      def define_column(name, type: nil, label: nil, transformer: nil, options: {})
        name = name.to_sym
        type ||= model.columns_hash[name.to_s]&.type

        custom_definition = { label:, transformer:, options: }.compact
        @definitions[name] = build_definition(name, type).deep_merge custom_definition
        self
      end

      def only!(*columns)
        @columns.slice!(*columns.flatten)
        self
      end

      def except!(*columns)
        @columns.except!(*columns.flatten)
        self
      end

      def column_names
        columns.values.pluck(:label)
      end

      def columns
        @definitions.slice(*@columns.keys)
      end

      def column?(name)
        @columns.key? name
      end

      def column_defined?(name)
        @definitions.key? name
      end

      protected

      def build_definition(name, type)
        options = {
          max_width: 250
        }

        transformer = ->(value) { value }
        case type
        when :string, :text, :citext
          options[:max_width] = 400
        when :integer, :float, :decimal
          transformer = ->(value) { number_with_delimiter value }
        when :datetime, :timestamp, :time, :date
          transformer = ->(value) { timeago value }
        when :boolean
          transformer = ->(value) { tag.input(class: 'form-check-input', type: 'checkbox', checked: value) }
        end
        # binary:      { name: "blob" },
        # blob:        { name: "blob" },
        # json:        { name: "json" },

        if name.ends_with? '_url'
          transformer = ->(value) { tag.a value, href: value, class: 'text-decoration-none', target: :blank }
        end

        {
          name:,
          type:,
          label: name.to_s.titleize(keep_id_suffix: true),
          transformer:,
          options:
        }
      end
    end
  end
end
