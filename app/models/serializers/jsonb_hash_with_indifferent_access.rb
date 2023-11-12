# frozen_string_literal: true

module Serializers
  class JsonbHashWithIndifferentAccess
    class << self
      def dump(obj)
        return HashWithIndifferentAccess.new if obj.nil?

        if obj.is_a? Hash
          HashWithIndifferentAccess.new(obj)
        elsif Rails.env.development? || Rails.env.test?
          raise "Attribute was supposed to be a Hash, but was a:\n\n#{obj.class} -- #{obj.inspect}"
        else
          obj
        end
      end

      def load(obj)
        return HashWithIndifferentAccess.new if obj.nil?

        if obj.is_a? Hash
          HashWithIndifferentAccess.new(obj)
        elsif Rails.env.development? || Rails.env.test?
          raise "Attribute was supposed to be a #{self}, but was a:\n\n#{obj.class} -- #{obj.inspect}"
        else
          obj
        end
      end
    end
  end
end
