# frozen_string_literal: true

module ButtonsHelper
  def toobar_icon_button(url, icon, clazz = :secondary)
    tag.a href: url, class: "btn btn-sm btn-outline-#{clazz} toolbar-icon-button", data: { turbo_frame: '_top' } do
      tag.i class: "bi bi-#{icon}"
    end
  end

  def toobar_back_button(fallback = nil)
    url = url_for(:back)
    url = fallback if url == 'javascript:history.back()'
    toobar_icon_button url, 'box-arrow-right' if url.present?
  end

  def delete_button_for(record)
    form_for record, method: :delete, html: { class: 'd-inline-block', data: { turbo_confirm: 'Are you sure?' } } do
      button_to record, class: 'btn btn-sm btn-outline-danger toolbar-icon-button' do
        tag.i class: 'bi bi-trash'
      end
    end
  end

  def edit_button_for(record)
    path_helper = "edit_#{record.class.to_s.underscore}_path".to_sym
    path = send path_helper, record
    toobar_icon_button path, :pencil, :primary
  end
end
