# frozen_string_literal: true

require_relative "lib/the_one_api/version"

Gem::Specification.new do |spec|
  spec.name = "the_one_api"
  spec.version = TheOneApi::VERSION
  spec.authors = ["Joshua Samberg"]
  spec.email = ["iceberg901@gmail.com"]

  spec.summary = "An Ruby gem providing an SDK for interacting with The One API"
  spec.description = spec.summary
  spec.homepage = "https://github.com/iceberg901/joshua-samberg-sdk"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.0"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .circleci appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "flexirest", "~> 1.11.1"

  spec.add_development_dependency "dotenv", "~> 2.8.1"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rubocop", "~> 1.52"
  spec.add_development_dependency "vcr", "~> 6.1.0"
end
