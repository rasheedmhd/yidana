# frozen_string_literal: true

module Pu
  module UI
    module Action
      class Action
        attr_reader :name, :button, :route, :confirmation

        def initialize(name, button:, route: {})
          route = OpenStruct.new route.reverse_merge(method: :get, options: {})

          @name = name
          @button = button
          @route = route
        end

        def with_confirmation(confirmation)
          @confirmation = confirmation
          self
        end

        class << self
          def create_action(button: nil)
            button ||= Pu::UI::Button.create_button

            new :create, button:, route: { action: :new }
          end

          def show_action(button: nil)
            button ||= Pu::UI::Button.show_button

            new :show, button:
          end

          def edit_action(button: nil)
            button ||= Pu::UI::Button.edit_button

            new :edit, button:, route: { action: :edit }
          end

          def destroy_action(button: nil)
            button ||= Pu::UI::Button.destroy_button

            new(:destroy, button:, route: { method: :delete }).with_confirmation 'Are you sure?'
          end
        end
      end
    end
  end
end
