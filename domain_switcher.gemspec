Gem::Specification.new do |s|
  s.name = "domain_switcher"
  s.version = "0.1.0"
  s.author = "Guillaume Luccisano"
  s.email = "guillaume@justin.tv"
  s.homepage = "http://www.justin.tv"
  s.summary = "Rack based domain switcher with configuration"
  s.description = "Rack based domain switcher with configuration"

  s.add_dependency('rack', '>= 1.1.0')

  s.files = Dir["{lib,spec}/**/*", "[A-Z]*", "init.rb"]
  s.require_path = "lib"

  s.rubyforge_project = s.name
  s.required_rubygems_version = ">= 1.3.4"
end