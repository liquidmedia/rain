$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "rain/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "rain"
  s.version     = Rain::VERSION
  s.authors     = ["Dan Williams"]
  s.email       = ["dan@liquidmedia.ca"]
  s.homepage    = "http://liquidmedia.ca"
  s.summary     = "Quick and easy text editing"
  s.description = "Quick and easy text editing"

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", ">= 3.2.0.rc2"
  # s.add_dependency "jquery-rails"

  s.add_development_dependency "sqlite3"
end
