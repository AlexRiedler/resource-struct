# frozen_string_literal: true

require_relative "resource_struct/version"

module ResourceStruct
  class Error < StandardError; end
end

require_relative "resource_struct/firm_struct"
require_relative "resource_struct/loose_struct"
