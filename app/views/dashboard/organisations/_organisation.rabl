# frozen_string_literal: true

attributes :id
attributes(*@permitted_attributes)
attributes :created_at, :updated_at

node(:url) { |organisation| organisation_url(organisation) }
