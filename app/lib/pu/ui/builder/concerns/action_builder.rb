# frozen_string_literal: true

module Pu
  module UI
    module Builder
      module Concerns
        module ActionBuilder
          def initialize
            @enabled_actions = {} # using hash since keys act as an ordered set
            @action_definitions = {}
          end

          def define_action(action)
            name = action.name
            @enabled_actions[name] = true
            @action_definitions[name] = action
            self
          end

          def only!(*actions)
            @enabled_actions.slice!(*actions.flatten.map(&:to_sym))
            self
          end

          def except!(*actions)
            @enabled_actions.except!(*actions.flatten.map(&:to_sym))
            self
          end

          def permitted_actions_for(policy)
            permitted_actions = @enabled_actions.keys.select { |name| policy.send "#{name}?".to_sym }
            @action_definitions.slice(*permitted_actions)
          end

          def action_defined?(name)
            @action_definitions.key? name.to_sym
          end
        end
      end
    end
  end
end
