# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{impressionist}
  s.version = "0.4.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["cowboycoded"]
  s.date = %q{2011-06-03}
  s.description = %q{Log impressions from controller actions or from a model}
  s.email = %q{john.mcaliley@gmail.com}
  s.extra_rdoc_files = [
    "LICENSE.txt",
    "README.md"
  ]
  s.files = [
    "CHANGELOG.rdoc",
    "Gemfile",
    "LICENSE.txt",
    "README.md",
    "Rakefile",
    "VERSION",
    "app/controllers/impressionist_controller.rb",
    "app/models/impression.rb",
    "app/models/impressionist/bots.rb",
    "app/models/impressionist/impressionable.rb",
    "config/routes.rb",
    "impressionist.gemspec",
    "lib/generators/impressionist/impressionist_generator.rb",
    "lib/generators/impressionist/templates/create_impressions_table.rb",
    "lib/impressionist.rb",
    "lib/impressionist/bots.rb",
    "lib/impressionist/engine.rb",
    "lib/impressionist/railties/tasks.rake",
    "logo.png",
    "upgrade_migrations/version_0_3_0.rb",
    "upgrade_migrations/version_0_4_0.rb"
  ]
  s.homepage = %q{http://github.com/cowboycoded/impressionist}
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{Easy way to log impressions}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<shoulda>, [">= 0"])
      s.add_development_dependency(%q<bundler>, ["~> 1.0.0"])
      s.add_development_dependency(%q<jeweler>, ["~> 1.5.1"])
      s.add_development_dependency(%q<rcov>, [">= 0"])
    else
      s.add_dependency(%q<shoulda>, [">= 0"])
      s.add_dependency(%q<bundler>, ["~> 1.0.0"])
      s.add_dependency(%q<jeweler>, ["~> 1.5.1"])
      s.add_dependency(%q<rcov>, [">= 0"])
    end
  else
    s.add_dependency(%q<shoulda>, [">= 0"])
    s.add_dependency(%q<bundler>, ["~> 1.0.0"])
    s.add_dependency(%q<jeweler>, ["~> 1.5.1"])
    s.add_dependency(%q<rcov>, [">= 0"])
  end
end

