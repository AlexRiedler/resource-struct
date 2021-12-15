# frozen_string_literal: true

module ResourceStruct
  #
  # LooseStruct provides a struct by which accessing undefined fields returns nil
  #
  # struct = LooseStruct.new({ "foo" => 1, "bar" => [{ "baz" => 2 }, 3] })
  #
  # struct.foo? # => true
  # struct.brr? # => false
  # struct.foo # => 1
  # struct.bar # => [LooseStruct<{ "baz" => 2 }>, 3]
  # struct.brr # => nil
  # struct[:foo] # => 1
  # struct[:brr] # => nil
  # struct[:bar, 0, :baz] # => 2
  # struct[:bar, 0, :brr] # => nil
  #
  class LooseStruct
    def initialize(hash)
      raise ::ArgumentError, "first argument must be a Hash, found #{hash.class.name}" unless hash.is_a?(Hash)

      @hash = hash
      @ro_struct = {}
    end

    def method_missing(name, *_args)
      return self[name] if ___key?(name)
      return !!self[___convert_key(name[...-1])] if name.end_with?("?")

      nil
    end

    def respond_to_missing?(_name, _include_private = false)
      true
    end

    def to_h
      @hash.to_h
    end

    def to_hash
      @hash.to_hash
    end

    def inspect
      "#{self.class.name}<#{@hash.inspect}>"
    end

    def to_s
      @hash.to_s
    end

    def ==(other)
      @hash == other.instance_variable_get(:@hash)
    end

    def [](key, *sub_keys)
      ckey = ___convert_key(key)

      result =
        if @ro_struct.key?(ckey)
          @ro_struct[ckey]
        else
          @ro_struct[ckey] = ___convert_value(@hash[ckey])
        end

      return result if sub_keys.empty?

      return unless result

      raise TypeError, "#{result.class.name} does not have #dig method" unless result.respond_to?(:dig)

      result.dig(*sub_keys)
    end
    alias dig []

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
      @hash.key?(___convert_key(key))
    end

    def ___convert_key(key)
      key.is_a?(::Symbol) ? key.to_s : key
    end
  end
end
