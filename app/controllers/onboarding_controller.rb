# frozen_string_literal: true

class OnboardingController < ApplicationController
  include CurrentUser

  layout 'onboarding'

  def new; end

  def create
    name = params.require :name
    entity = Recruiter.create! name:, user: current_user
    EntityUser.create! entity:, user: current_user, role: :owner

    session[:current_entity] = entity.id
    redirect_to entity_path(entity), success: "#{name} created successfully"
  end
end
