# frozen_string_literal: true

module Pu
  module Builders
    module Action
      class IconButton
        include ActionView::Helpers::TagHelper

        attr_reader :icon, :button_class, :action, :method, :confirm

        def initialize(icon:, button_class:, action:, method:, confirm:)
          @icon = icon
          @button_class = button_class
          @action = action
          @method = method
          @confirm = confirm
        end

        class << self
          def create(icon: 'plus-lg', button_class: 'primary')
            new icon:, button_class:, action: :new, method: :get, confirm: nil
          end

          def show(icon: 'box-arrow-up-right', button_class: 'primary')
            new icon:, button_class:, action: nil, method: :get, confirm: nil
          end

          def edit(icon: 'pencil', button_class: 'warning-emphasis')
            new icon:, button_class:, action: :edit, method: :get, confirm: nil
          end

          def destroy(icon: 'trash', button_class: 'danger', confirm: 'Are you sure?')
            new icon:, button_class:, action: nil, method: :delete, confirm:
          end
        end
      end
    end
  end
end
