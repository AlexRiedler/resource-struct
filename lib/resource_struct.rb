# frozen_string_literal: true

require_relative "resource_struct/version"

#
# ResourceStruct
#
# includes the factory method ResourceStruct.new(hash, opts)
# for building the various types of structs provided by the library.
#
module ResourceStruct
  class Error < StandardError; end
end

require_relative "resource_struct/extensions/indifferent_lookup"
require_relative "resource_struct/strict_struct"
require_relative "resource_struct/flex_struct"
