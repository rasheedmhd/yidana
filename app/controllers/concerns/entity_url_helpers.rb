# frozen_string_literal: true

module EntityUrlHelpers
  def self.included(base)
    base.send :before_action, :add_url_helpers
  end

  private

  def add_url_helpers
    # Skip this on api only controllers
    return unless self.class.respond_to? :helper_method

    Rails.application.routes.named_routes.helper_names.each do |name|
      next unless entity_url_helper? name

      method_name = to_url_helper name
      self.class.send :helper_method, method_name
    end
  end

  def method_missing(method_name, *args, &block)
    if url_helper? method_name
      # put the current entity at the top of the argument list
      args.unshift current_entity
      # invoke the entity helper method
      method_name = to_entity_url_helper method_name
      send method_name.to_sym, *args, &block
    else
      super
    end
  end

  def respond_to_missing?(method_name, include_private = false)
    url_helper? method_name || super
  end

  def url_helper?(name)
    /(_path|_url)$/.match? name.to_s
  end

  def entity_url_helper?(name)
    /entity_/.match?(name) && !/^(entity_path|entity_url)$/.match?(name)
  end

  def to_entity_url_helper(name)
    name = name.to_s
    prefix = /^(new|edit)_/.match name
    name = if prefix
             subbed = name.gsub(/^#{prefix}/, 'entity_')
             "#{prefix}#{subbed}"
           else
             "entity_#{name}"
           end
    name.to_sym
  end

  def to_url_helper(name)
    name.gsub(/entity_/, '').to_sym
  end
end
