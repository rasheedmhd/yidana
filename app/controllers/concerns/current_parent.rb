# frozen_string_literal: true

#
# Sets the current parent in the :detect_current_parent before action
#
# Current parent is available via #current_parent
#
module CurrentParent
  def self.included(base)
    base.send :include, CurrentEntity

    base.send :before_action, :detect_current_parent
    base.send :helper_method, :current_parent
  end

  private

  #
  # Detects if a parent is set in route and sets it to an instance variable
  #
  def detect_current_parent
    parent_key = (params.keys.last(3) - %w[controller action entity id]).first

    return unless parent_key.present?

    parent_name = parent_key.gsub(/_id$/, '')
    parent_association = parent_name.pluralize.to_sym

    slugged = parent_name.classify.constantize.include? Slugged
    find_key = slugged ? :slug : :id
    find_value = params[parent_key]

    @current_parent = current_entity.send(parent_association).where(find_key => find_value).first!
  end

  def current_parent
    @current_parent
  end
end
