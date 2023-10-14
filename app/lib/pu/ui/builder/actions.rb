# frozen_string_literal: true

module Pu
  module UI
    module Builder
      class Actions
        include Concerns::DefinesActions

        def with_standard_actions
          %i[create_action show_action edit_action destroy_action].each do |action|
            define_action Pu::UI::Action.send(action)
          end
          self
        end
      end
    end
  end
end
