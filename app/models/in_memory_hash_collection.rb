# frozen_string_literal: true

module InMemoryHashCollection
  def self.included(base)
    base.send :attr_reader, :id
    base.send :extend, ClassMethods
  end

  def initialize(id)
    @id = id
  end

  def name
    self.class::HASH[id]
  end

  def to_s
    id
  end

  def ==(other)
    case other
    when self.class
      id == other.id
    when String
      id == other
    else
      super
    end
  end

  module ClassMethods
    def dump(obj)
      return if obj.nil?

      if obj.is_a?(self)
        obj.id
      elsif self::HASH.key?(obj)
        obj
      elsif obj.is_a? Array
        obj.map { |i| dump i }.compact
      elsif obj.blank?
        nil
      elsif Rails.env.development? || Rails.env.test?
        raise "Attribute was supposed to be a #{self}, but was a:\n\n#{obj.class} -- #{obj.inspect}"
      end
    end

    def load(obj)
      return if obj.nil?

      if obj.is_a?(self)
        obj
      elsif self::HASH.key?(obj)
        new obj
      elsif obj.is_a? Array
        obj.map { |i| load i }.compact
      elsif obj.blank?
        nil
      elsif Rails.env.development? || Rails.env.test?
        raise "Attribute was supposed to be a #{self}, but was a:\n\n#{obj.class} -- #{obj.inspect}"
      end
    end

    def collection
      @collection ||= ids.map { |id| new id }
    end

    def ids
      @ids ||= self::HASH.keys.freeze
    end

    def [](key)
      self::HASH[key]
    end
  end
end
