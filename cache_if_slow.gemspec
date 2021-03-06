# frozen_string_literal: true

require_relative "lib/cache_if_slow/version"

Gem::Specification.new do |spec|
  spec.name = "cache_if_slow"
  spec.version = CacheIfSlow::VERSION
  spec.authors = ["Cian McElhinney"]
  spec.email = ["cache_if_slow@cme.33mail.com"]

  spec.summary = "Auto cache slow requests."
  spec.description = "Auto cache slow requests or blocks of code."
  spec.homepage = "https://github.com/cianmce/cache_if_slow"
  spec.license = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["documentation_uri"] = "https://www.rubydoc.info/gems/cache_if_slow/#{CacheIfSlow::VERSION}"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "standardrb", "~> 1.0"
  spec.add_development_dependency "bundler", ">= 1"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.10"
  spec.add_development_dependency "pry", "~> 0.13.0"
  spec.add_development_dependency "pry-byebug", "~> 3.9"
  spec.add_development_dependency "pry-doc", "~> 1.1"
  spec.add_development_dependency "guard", "~> 2.18"
  spec.add_development_dependency "guard-rspec", "~> 4.7.3"
  spec.add_dependency "rails", ">= 4.0"
end
