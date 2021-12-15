# frozen_string_literal: true

require_relative "lib/resource_struct/version"

Gem::Specification.new do |spec|
  spec.name = "resource-struct"
  spec.version = ResourceStruct::VERSION
  spec.authors = ["Alex Riedler"]
  spec.email = ["alex@riedler.ca"]

  spec.summary = "Ruby structs for resource responses"
  spec.description = "Openstruct like access without all the headaches of Hash method overrides etc..."
  spec.homepage = "https://github.com/AlexRiedler/resource-struct"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.7.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/AlexRiedler/resource-struct"
  spec.metadata["changelog_uri"] = "https://raw.githubusercontent.com/AlexRiedler/resource-struct/master/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:test|spec|features)/|\.(?:git|travis|circleci|github)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"

  # For more information and examples about making a new gem, checkout our
  # guide at: https://bundler.io/guides/creating_gem.html
end
