# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "russian"
  s.version = "0.2.7"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Yaroslav Markin"]
  s.autorequire = "russian"
  s.date = "2010-05-05"
  s.description = "Russian language support for Ruby and Rails"
  s.email = "yaroslav@markin.net"
  s.extra_rdoc_files = ["README.textile", "LICENSE", "CHANGELOG", "TODO"]
  s.files = ["README.textile", "LICENSE", "CHANGELOG", "TODO"]
  s.homepage = "http://github.com/yaroslav/russian/"
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.10"
  s.summary = "Russian language support for Ruby and Rails"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
