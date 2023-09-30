# frozen_string_literal: true

#
# Requires the current entity in the :require_current_entity before action
# Current entity is available via #current_entity
#
module CurrentEntity
  def self.included(base)
    base.send :include, CurrentUser

    base.send :before_action, :current_entity
    base.send :before_action, :require_current_entity
    base.send :helper_method, :current_entity
  end

  private

  #
  # Redirect to onboarding page if current_entity is not set
  #
  # Updates the current session with the current entity if it is set
  #
  # @see Dashboard#current_entity
  #
  def require_current_entity
    if current_entity.present?
      session[:current_entity] = current_entity.id
    else
      redirect_to onboarding_path
    end
  end

  def current_entity
    # Raise NotFound if user does not have access to the entity
    @current_entity ||= current_user.entities.where(slug: params.require(:entity)).first!
  end
end
