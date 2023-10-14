# frozen_string_literal: true

module Pu
  module Helpers
    module ButtonsHelper
      def generic_icon_button(url, icon:, button_class:, method:, confirm:)
        if method == :get
          link_to url, class: button_class do
            tag.i class: "bi bi-#{icon}"
          end
        else
          form_for :action, url:, method:, html: { class: 'd-inline-block', data: { turbo_confirm: confirm } } do
            tag.button class: button_class do
              tag.i class: "bi bi-#{icon}"
            end
          end
        end
      end

      def toolbar_icon_button(url, icon:, button_class: 'secondary', method: :get, confirm: nil)
        button_class = "btn btn-sm btn-outline-#{button_class} toolbar-icon-button"

        generic_icon_button(url, icon:, button_class:, method:, confirm:)
      end

      def table_icon_button(url, icon:, button_class: 'secondary', method: :get, confirm: nil)
        button_class = "btn btn-sm btn-link text-#{button_class}"

        generic_icon_button(url, icon:, button_class:, method:, confirm:)
      end
    end
  end
end
