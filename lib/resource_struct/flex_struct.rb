# frozen_string_literal: true

module ResourceStruct
  #
  # FlexStruct provides a struct by which accessing undefined fields returns nil
  #
  # struct = FlexStruct.new({ "foo" => 1, "bar" => [{ "baz" => 2 }, 3] })
  #
  # struct.foo? # => true
  # struct.brr? # => false
  # struct.foo # => 1
  # struct.bar # => [FlexStruct<{ "baz" => 2 }>, 3]
  # struct.brr # => nil
  # struct[:foo] # => 1
  # struct[:brr] # => nil
  # struct[:bar, 0, :baz] # => 2
  # struct[:bar, 0, :brr] # => nil
  #
  class FlexStruct
    include ::ResourceStruct::Extensions::IndifferentLookup

    def []=(key, value)
      ckey = ___convert_key(key)
      @ro_struct.delete(ckey)

      value = value.instance_variable_get(:@hash) if value.is_a?(FlexStruct) || value.is_a?(StrictStruct)

      if @hash.key?(key)
        @hash[key] = value
      elsif key.is_a?(String) && @hash.key?(key.to_sym)
        @hash[key.to_sym] = value
      elsif key.is_a?(Symbol) && @hash.key?(key.to_s)
        @hash[key.to_s] = value
      else
        @hash[key] = value
      end
    end

    def method_missing(name, *args)
      if name.end_with?("=")
        return self[name[...-1]] = args.first if args.length == 1

        raise ArgumentError, "expected 1 argument received #{args.length} arguments"
      elsif name.end_with?("?")
        return !!self[name[...-1]] if args.empty?
      elsif args.empty?
        return self[name]
      end

      raise ArgumentError, "expected 0 arguments received #{args.length} arguments"
    end

    def respond_to_missing?(name, include_private = false)
      ___key?(name) || ___key?(name.to_s.chomp("?")) || super
    end
  end
  LooseStruct = FlexStruct
end
