# frozen_string_literal: true

require "forwardable"

module ResourceStruct
  module Extensions
    #
    # Common code between FirmStruct and LooseStruct
    #
    module IndifferentLookup
      extend Forwardable

      def_delegators :@hash, :to_h, :to_hash, :to_s, :as_json, :to_json

      def initialize(hash = {})
        @hash = hash || {}
        @ro_struct = {}

        raise ::ArgumentError, "first argument must be a Hash, found #{hash.class.name}" unless hash.is_a?(Hash)
      end

      def inspect
        "#{self.class.name}<#{@hash.inspect}>"
      end

      def ==(other)
        other.is_a?(Hash) && ___all_keys_equal(other) ||
          (other.is_a?(LooseStruct) || other.is_a?(FirmStruct)) &&
            ___all_keys_equal(other.instance_variable_get(:@hash))
      end

      def dig(key, *sub_keys)
        ckey = ___convert_key(key)

        result =
          if @ro_struct.key?(ckey)
            @ro_struct[ckey]
          elsif key.is_a?(String)
            @ro_struct[ckey] = ___convert_value(@hash[key] || @hash[key.to_sym])
          else
            @ro_struct[ckey] = ___convert_value(@hash[key] || @hash[ckey])
          end

        return result if sub_keys.empty?

        return unless result

        raise TypeError, "#{result.class.name} does not have #dig method" unless result.respond_to?(:dig)

        result.dig(*sub_keys)
      end
      alias [] dig

      private

      def ___convert_value(value)
        case value
        when ::Array
          value.map { |v| ___convert_value(v) }.freeze
        when Hash
          self.class.new(value)
        else
          value
        end
      end

      def ___key?(key)
        @hash.key?(key) || @hash.key?(___convert_key(key))
      end

      def ___convert_key(key)
        key.is_a?(::Symbol) ? key.to_s : key
      end

      def ___all_keys_equal(other)
        return false unless @hash.count == other.count

        @hash.reduce(true) do |acc, (k, _)|
          value = self[k]
          if other.key?(k)
            acc && value == other[k]
          elsif k.is_a?(String)
            ck = k.to_sym
            acc && other.key?(ck) && value == other[ck]
          else
            ck = ___convert_key(k)
            acc && other.key?(ck) && value == other[ck]
          end
        end
      end
    end
  end
end
