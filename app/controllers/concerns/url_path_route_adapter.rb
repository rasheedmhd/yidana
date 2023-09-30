# frozen_string_literal: true

module UrlPathRouteAdapter
  def self.included(base)
    base.send :helper_method, :adapt_route_args
  end

  private

  #
  # Returns a dynamic list of args to be used with `url_for` which considers the route namespace and nesting.
  # The current entity and parent record (for nested routes) are inserted appropriately, ensuring that generated urls
  # obey the current routing.
  #
  # e.g. of route helpers that will be invoked given the output of this method
  #
  # - when invoked in a root route (/acme/dashboard/users)
  #
  # `adapt_route_args User`                   => `entity_users_*`
  # `adapt_route_args @user`                  => `entity_user_*`
  # `adapt_route_args @user, action: :edit`   => `edit_entity_user_*`
  # `adapt_route_args @user, Post             => `entity_user_posts_*`
  #
  # - when invoked in a nested route (/acme/dashboard/users/1/post/1)
  #
  # `adapt_route_args Post`                   => `entity_user_posts_*`
  # `adapt_route_args @post`                  => `entity_user_post_*`
  # `adapt_route_args @post, action: :edit`   => `edit_entity_user_post_*`
  #
  # @param [Class, ApplicationRecord] *args arguments you would normally pass to `url_for`
  # @param [Symbol] action optional action to invoke e.g. :new, :edit
  #
  # @return [Array[Class, ApplicationRecord, Symbol]] args to pass to `url_for`
  #
  def adapt_route_args(*args, action: nil, use_parent: true)
    # If the last item is a class and an action is passed e.g. `adapt_route_args User, action: :new`,
    # it must be converted into a symbol to generate the appropriate helper i.e `new_entity_user_*`
    resource = args.pop
    resource = resource.to_s.underscore.to_sym if action.present? && resource.is_a?(Class)
    args.push resource

    parent = use_parent ? current_parent : nil

    # rails compacts this list. no need to handle nils
    [action, current_entity.becomes(Entity), parent] + args
  end
end
