# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{heroku-api}
  s.version = "0.3.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["geemus (Wesley Beary)"]
  s.date = %q{2012-08-01}
  s.description = %q{Ruby Client for the Heroku API}
  s.email = ["wesley@heroku.com"]
  s.files = ["test/data/server.crt", "test/data/server.key", "test/test_addons.rb", "test/test_apps.rb", "test/test_collaborators.rb", "test/test_config_vars.rb", "test/test_domains.rb", "test/test_features.rb", "test/test_helper.rb", "test/test_keys.rb", "test/test_login.rb", "test/test_logs.rb", "test/test_processes.rb", "test/test_releases.rb", "test/test_ssl_endpoints.rb", "test/test_stacks.rb", "test/test_user.rb"]
  s.homepage = %q{http://github.com/heroku/heroku.rb}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.6.2}
  s.summary = %q{Ruby Client for the Heroku API}
  s.test_files = ["test/data/server.crt", "test/data/server.key", "test/test_addons.rb", "test/test_apps.rb", "test/test_collaborators.rb", "test/test_config_vars.rb", "test/test_domains.rb", "test/test_features.rb", "test/test_helper.rb", "test/test_keys.rb", "test/test_login.rb", "test/test_logs.rb", "test/test_processes.rb", "test/test_releases.rb", "test/test_ssl_endpoints.rb", "test/test_stacks.rb", "test/test_user.rb"]

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<excon>, ["~> 0.15.5"])
      s.add_development_dependency(%q<minitest>, [">= 0"])
      s.add_development_dependency(%q<rake>, [">= 0"])
    else
      s.add_dependency(%q<excon>, ["~> 0.15.5"])
      s.add_dependency(%q<minitest>, [">= 0"])
      s.add_dependency(%q<rake>, [">= 0"])
    end
  else
    s.add_dependency(%q<excon>, ["~> 0.15.5"])
    s.add_dependency(%q<minitest>, [">= 0"])
    s.add_dependency(%q<rake>, [">= 0"])
  end
end
