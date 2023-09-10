# frozen_string_literal: true

module ApplicationHelper
  def timeago(date, format: :long)
    return if date.blank?

    content = I18n.l(date, format:)
    tag.time(
      content,
      title: content,
      data: {
        controller: 'timeago',
        timeago_refresh_interval_value: 1000,
        timeago_include_seconds_value: true,
        timeago_add_suffix_value: true,
        timeago_datetime_value: date.iso8601
      }
    )
  end

  def tooltip(text)
    text = sanitize text
    "title=\"#{text}\" data-controller=\"tooltip\" data-bs-title=\"#{text}\"".html_safe
  end

  def display_name_of(obj)
    return unless obj.present?

    return obj.map { |i| display_name_of i }.join ', ' if obj.is_a? Array

    name_method = nil
    %i[display_name name].each do |method|
      return obj.send method if obj.respond_to? method
    end

    return "#{obj.class} #{obj.id}" if obj.respond_to? :id

    obj.to_s
  end
end
