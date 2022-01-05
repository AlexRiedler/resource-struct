# frozen_string_literal: true

module ResourceStruct
  #
  # StrictStruct provides a struct by which accessing undefined fields raises a MethodMissing error.
  # This protects against accessing fields that are not present in API Responses.
  #
  # If you need to check whether a field exists in an api response, you can via name? methods.
  #
  # struct = StrictStruct.new({ "foo" => 1, "bar" => [{ "baz" => 2 }, 3] })
  #
  # struct.foo? # => true
  # struct.brr? # => false
  # struct.foo # => 1
  # struct.bar # => [StrictStruct<{ "baz" => 2 }>, 3]
  # struct.brr # => NoMethodError
  # struct[:foo] # => 1
  # struct[:brr] # => nil
  # struct[:bar, 0, :baz] # => 2
  # struct[:bar, 0, :brr] # => nil
  #
  class StrictStruct
    include ::ResourceStruct::Extensions::IndifferentLookup

    def method_missing(name, *args, &blk)
      args_length = args.length
      return self[name] if ___key?(name) && args_length.zero?
      return !!self[name[...-1]] if name.end_with?("?") && args_length.zero?

      super
    end

    def respond_to_missing?(name, include_private = false)
      ___key?(name) || name.end_with?("?") || super
    end
  end
  FirmStruct = StrictStruct
end
