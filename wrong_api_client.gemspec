
Gem::Specification.new do |s|

  s.name = 'wrong_api_client'

  s.version = File.read(
    File.expand_path('../lib/wac/version.rb', __FILE__)
  ).match(/ VERSION *= *['"]([^'"]+)/)[1]

  s.platform = Gem::Platform::RUBY
  s.authors = [ 'John Mettraux' ]
  s.email = [ 'jmettraux@gmail.com' ]
  s.homepage = 'http://rightscale.com'
  #s.rubyforge_project = 'nada'
  s.summary = 'a lean RightAPI client'
  s.description = %{
a lean RightAPI client
  }

  #s.files = `git ls-files`.split("\n")
  s.files = Dir[
    'Rakefile',
    'lib/**/*.rb', 'spec/**/*.rb', 'test/**/*.rb',
    '*.gemspec', '*.txt', '*.rdoc', '*.md', '*.mdown'
  ]

  s.add_runtime_dependency 'rufus-json'
  s.add_runtime_dependency 'net-http-persistent', '>= 2.1'

  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'yajl-ruby'

  s.require_path = 'lib'
end

