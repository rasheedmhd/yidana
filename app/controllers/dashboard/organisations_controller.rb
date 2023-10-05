# frozen_string_literal: true

module Dashboard
  class OrganisationsController < BaseController
    controller_for Organisation, :name_cont
  end
end
