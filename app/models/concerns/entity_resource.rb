# frozen_string_literal: true

module EntityResource
  def self.included(base)
    base.send :include Slugged
  end
end
