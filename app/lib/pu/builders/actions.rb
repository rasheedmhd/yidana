# frozen_string_literal: true

module Pu
  module Builders
    class Actions
      include ActionView::Helpers::TagHelper

      attr_reader :actions, :definitions

      def initialize
        @actions = {} # using hash since keys act as an ordered set
        @definitions = {}
      end

      def with_standard_actions
        %i[create show edit destroy].each do |action|
          with_action action, Action::IconButton.send(action)
        end
        self
      end

      def with_action(name, action)
        name = name.to_sym
        @actions[name] = true
        @definitions[name] = action
        self
      end

      def only!(*actions)
        @actions.slice!(*actions.flatten.map(&:to_sym))
        self
      end

      def except!(*actions)
        @actions.except!(*actions.flatten.map(&:to_sym))
        self
      end

      def permitted_actions_for(policy)
        actions = @actions.keys.select { |name| policy.send "#{name}?".to_sym }
        @definitions.slice(*actions).values
      end

      def action_defined?(name)
        @definitions.key? name.to_sym
      end
    end
  end
end
