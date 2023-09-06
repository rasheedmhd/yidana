# frozen_string_literal: true

module Slugged
  def to_param
    return nil unless persisted?

    slug
  end
end
