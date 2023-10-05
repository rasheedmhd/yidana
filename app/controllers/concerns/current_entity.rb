# frozen_string_literal: true

#
# Makes the current entity available via #current_entity
#
# Updates the session with the current entity id.
#
module CurrentEntity
  def self.included(base)
    base.send :before_action, :remember_current_entity
    base.send :helper_method, :current_entity
  end

  private

  #
  # Update the session with the current entity
  #
  # @see Dashboard#current_entity
  #
  def remember_current_entity
    return unless current_entity.present?

    session[:current_entity] = current_entity.id
  end

  def current_entity
    return unless respond_to?(:current_user, true)

    # Raise NotFound if user does not have access to the entity or it does not exist
    @current_entity ||= current_user.entities.from_path_param(params.require(:entity_id)).first!
  end
end
