# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{launchy}
  s.version = "2.1.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Jeremy Hinegardner"]
  s.date = %q{2012-07-28}
  s.default_executable = %q{launchy}
  s.description = %q{Launchy is helper class for launching cross-platform applications in a fire and forget manner. There are application concepts (browser, email client, etc) that are common across all platforms, and they may be launched differently on each platform. Launchy is here to make a common approach to launching external application from within ruby programs.}
  s.email = %q{jeremy@copiousfreetime.org}
  s.executables = ["launchy"]
  s.files = ["spec/application_spec.rb", "spec/applications/browser_spec.rb", "spec/cli_spec.rb", "spec/detect/host_os_family_spec.rb", "spec/detect/host_os_spec.rb", "spec/detect/nix_desktop_environment_spec.rb", "spec/detect/ruby_engine_spec.rb", "spec/detect/runner_spec.rb", "spec/launchy_spec.rb", "spec/mock_application.rb", "spec/spec_helper.rb", "spec/tattle-host-os.yaml", "spec/version_spec.rb", "bin/launchy"]
  s.homepage = %q{http://github.com/copiousfreetime/launchy}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.6.2}
  s.summary = %q{Launchy is helper class for launching cross-platform applications in a fire and forget manner.}
  s.test_files = ["spec/application_spec.rb", "spec/applications/browser_spec.rb", "spec/cli_spec.rb", "spec/detect/host_os_family_spec.rb", "spec/detect/host_os_spec.rb", "spec/detect/nix_desktop_environment_spec.rb", "spec/detect/ruby_engine_spec.rb", "spec/detect/runner_spec.rb", "spec/launchy_spec.rb", "spec/mock_application.rb", "spec/spec_helper.rb", "spec/tattle-host-os.yaml", "spec/version_spec.rb"]

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<addressable>, ["~> 2.3"])
      s.add_development_dependency(%q<rake>, ["~> 0.9.2.2"])
      s.add_development_dependency(%q<minitest>, ["~> 3.3.0"])
      s.add_development_dependency(%q<rdoc>, ["~> 3.12"])
      s.add_development_dependency(%q<spoon>, ["~> 0.0.1"])
      s.add_development_dependency(%q<ffi>, ["~> 1.1.1"])
    else
      s.add_dependency(%q<addressable>, ["~> 2.3"])
      s.add_dependency(%q<rake>, ["~> 0.9.2.2"])
      s.add_dependency(%q<minitest>, ["~> 3.3.0"])
      s.add_dependency(%q<rdoc>, ["~> 3.12"])
      s.add_dependency(%q<spoon>, ["~> 0.0.1"])
      s.add_dependency(%q<ffi>, ["~> 1.1.1"])
    end
  else
    s.add_dependency(%q<addressable>, ["~> 2.3"])
    s.add_dependency(%q<rake>, ["~> 0.9.2.2"])
    s.add_dependency(%q<minitest>, ["~> 3.3.0"])
    s.add_dependency(%q<rdoc>, ["~> 3.12"])
    s.add_dependency(%q<spoon>, ["~> 0.0.1"])
    s.add_dependency(%q<ffi>, ["~> 1.1.1"])
  end
end
