# frozen_string_literal: true

require_relative "lib/typos/gem_version"

Gem::Specification.new do |spec|
  spec.name = "danger-typos"
  spec.version = Typos::VERSION
  spec.authors = ["Kyosuke Takayama"]
  spec.email = ["loiseau@gmail.com"]

  spec.summary = "Danger plugin for typos."
  spec.description = "Danger plugin for typos."
  spec.homepage = "https://github.com/ktakayama/danger-typos"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.2.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/ktakayama/danger-typos"
  spec.metadata["changelog_uri"] = "https://github.com/ktakayama/danger-typos"
  spec.metadata["rubygems_mfa_required"] = "true"

  spec.add_dependency "danger-plugin-api", "~> 1.0"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w(git ls-files -z), chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w(bin/ test/ spec/ features/ .git .github appveyor Gemfile))
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
end
