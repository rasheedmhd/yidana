# frozen_string_literal: true

module Pu
  module UI
    class Action
      attr_reader :name, :button, :route, :interaction, :confirm

      def initialize(name, button:, route: {}, interaction: nil, confirm: nil)
        default_route = { method: :get }
        default_route[:action] = :resource_action if interaction.present?
        route = OpenStruct.new default_route.merge(route)

        @name = name
        @button = button
        @interaction = interaction
        @route = route
        @confirm = confirm
      end

      class << self
        def create_action(button: nil)
          button ||= Button.create_button

          new :create, button:, route: { action: :new }
        end

        def show_action(button: nil)
          button ||= Button.show_button

          new :show, button:
        end

        def edit_action(button: nil)
          button ||= Button.edit_button

          new :edit, button:, route: { action: :edit }
        end

        def destroy_action(button: nil)
          button ||= Button.destroy_button

          new :destroy, button:, route: { method: :delete }, confirm: 'Are you sure?'
        end
      end
    end
  end
end
