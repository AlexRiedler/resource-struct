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
        hash = {} if hash.nil?
        raise ::ArgumentError, "first argument must be a Hash, found #{hash.class.name}" unless hash.is_a?(Hash)

        @hash = ___canonicalize_hash(hash)
        @ro_struct = {}
      end

      def inspect
        "#{self.class.name}<#{@hash.inspect}>"
      end

      def ==(other)
        other_hash = case other
                     when Hash then other
                     when LooseStruct, FirmStruct then other.instance_variable_get(:@hash)
                     else return false
                     end

        ___all_keys_equal(other_hash)
      end

      def dig(key, *sub_keys)
        ckey = ___convert_key(key)

        result = if @ro_struct.key?(ckey)
                   @ro_struct[ckey]
                 elsif @hash.key?(ckey)
                   @ro_struct[ckey] = ___convert_value(@hash[ckey])
                 end

        return result if sub_keys.empty?

        return unless result

        raise TypeError, "#{result.class.name} does not have #dig method" unless result.respond_to?(:dig)

        result.dig(*sub_keys)
      end
      alias [] dig

      def marshal_dump
        { data: @hash }
      end

      def marshal_load(obj)
        @ro_struct = {}
        @hash = ___canonicalize_hash(obj[:data] || {})
      end

      private

      def ___canonicalize_hash(hash)
        hash.each_with_object({}) do |(key, value), memo|
          memo[___convert_key(key)] = ___canonicalize_value(value)
        end
      end

      def ___canonicalize_value(value)
        case value
        when LooseStruct, FirmStruct
          value.instance_variable_get(:@hash)
        when ::Array
          value.map { |v| ___canonicalize_value(v) }
        when Hash
          ___canonicalize_hash(value)
        else
          value
        end
      end

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
        @hash.key?(___convert_key(key))
      end

      def ___convert_key(key)
        key.is_a?(::Symbol) ? key.to_s : key
      end

      def ___all_keys_equal(other)
        return false unless @hash.count == other.count

        @hash.all? do |k, _|
          other_value = if other.key?(k)
                          other[k]
                        elsif k.is_a?(String) && other.key?(k.to_sym)
                          other[k.to_sym]
                        else
                          return false
                        end
          self[k] == other_value
        end
      end
    end
  end
end
