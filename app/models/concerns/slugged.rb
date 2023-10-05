# frozen_string_literal: true

module Slugged
  def self.included(base)
    base.send :scope, :from_path_param, ->(param) { where(slug: param) }
  end

  def to_param
    return nil unless persisted?

    slug
  end
end
