# frozen_string_literal: true

module Pu
  module Table
    class Builder
      include ActionView::Helpers::NumberHelper
      include Pu::Helpers::ContentHelper
      include ActionView::Helpers::TagHelper

      attr_reader :model, :records, :columns, :pagination

      def initialize(model)
        @model = model
        @records = []
        @columns = {}
        # initialize with all columns except id
        with_columns(Organisation.columns.map(&:name) - [:id])
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
          with_column name
        end
        self
      end

      def with_column(name, type: nil, label: nil, transformer: nil, options: {})
        name = name.to_sym
        type ||= model.columns_hash[name.to_s]&.type

        column = { label:, transformer:, options: }.compact
        @columns[name] = build_column(name, type).deep_merge column
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
        @columns.values.pluck(:label)
      end

      protected

      def build_column(name, type)
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
          label: name.to_s.titleize,
          transformer:,
          options:
        }
      end
    end
  end
end
