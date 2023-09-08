# frozen_string_literal: true

module ApplicationHelper
  include Pagy::Frontend

  def timeago(date, format: :long)
    return if date.blank?

    content = I18n.l(date, format:)

    tag.time(content,
             title: content,
             data: {
               controller: 'timeago',
               timeago_refresh_interval_value: 1000,
               timeago_include_seconds_value: true,
               timeago_add_suffix_value: true,
               timeago_datetime_value: date.iso8601
             })
  end

  def pagination
    render partial: 'pagination', locals: { pagy: @pagy }
  end
end
