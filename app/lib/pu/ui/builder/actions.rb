# frozen_string_literal: true

module Pu
  module UI
    module Builder
      class Actions
        include Pu::UI::Concerns::DefinesActions

        def initialize
          initialize_actions_definer
        end

        def with_standard_actions
          %i[create_action show_action edit_action destroy_action].each do |factory|
            action = Pu::UI::Action::Action.send(factory)
            define_action action
            with_actions action.name
          end

          self
        end
      end
    end
  end
end
