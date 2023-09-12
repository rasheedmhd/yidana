# frozen_string_literal: true

module ButtonsHelper
  def toolbar_back_button(fallback = nil)
    url = url_for(:back)
    url = fallback if url == 'javascript:history.back()'
    toolbar_icon_button url, 'box-arrow-right' if url.present?
  end

  def toolbar_icon_button(url, icon, button_class = :secondary)
    button_class = __button__toolbar_icon_button_class(button_class)

    tag.a href: url, class: button_class do
      tag.i class: "bi bi-#{icon}"
    end
  end

  def table_icon_button(url, icon, button_class = :secondary)
    button_class = __button__table_icon_button_class(button_class)

    tag.a href: url, class: button_class do
      tag.i class: "bi bi-#{icon}"
    end
  end

  def show_button_for(record, button_class = :primary, variant: :toolbar)
    return unless can_perform?(record, :show)

    path = path_for record, :show
    __button__render_button_variant path, 'box-arrow-up-right', button_class, variant
  end

  def create_button_for(resource_class, button_class = :primary, variant: :toolbar)
    return unless can_perform?(resource_class, :create)

    path = path_for resource_class, :create
    __button__render_button_variant path, 'plus-lg', button_class, variant
  end

  def edit_button_for(record, button_class = :primary, variant: :toolbar)
    return unless can_perform?(record, :edit)

    path = path_for record, :edit
    __button__render_button_variant path, :pencil, button_class, variant
  end

  def delete_button_for(record, button_class = :danger, variant: :toolbar)
    return unless can_perform?(record, :delete)

    button_class = case variant
                   when :toolbar
                     __button__toolbar_icon_button_class(button_class)
                   when :table
                     __button__table_icon_button_class(button_class)
                   else
                     raise "Unknown button variant: #{variant}"
                   end

    form_for record, method: :delete, html: { class: 'd-inline-block', data: { turbo_confirm: 'Are you sure?' } } do
      tag.button(tag.i(class: 'bi bi-trash'),
                 class: button_class)
    end
  end

  def __button__render_button_variant(url, icon, button_class, variant)
    case variant
    when :table
      table_icon_button url, icon, button_class
    when :toolbar
      toolbar_icon_button url, icon, button_class
    else
      raise "Unknown button variant: #{variant}"
    end
  end

  def __button__toolbar_icon_button_class(button_class = :secondary)
    "btn btn-sm btn-outline-#{button_class} toolbar-icon-button"
  end

  def __button__table_icon_button_class(button_class = :secondary)
    "btn btn-sm btn-link text-#{button_class}"
  end
end
