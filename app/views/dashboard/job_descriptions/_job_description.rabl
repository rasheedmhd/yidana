# frozen_string_literal: true

attributes :id
attributes(*@permitted_attributes)
attributes :created_at, :updated_at

node(:url) { |job_description| job_description_url(job_description) }
