spec = Gem::Specification.new do |s|
  s.name = "breeder"
  s.version = "0.0.2"
  s.authors = ["Chris Kite", "Scott Reis"]
  s.homepage = "http://www.github.com/chriskite/breeder"
  s.platform = Gem::Platform::RUBY
  s.summary = "Process spawning and reaping"
  s.require_path = "lib"
  s.has_rdoc = false 
  #s.rdoc_options << '-m' << 'README.rdoc' << '-t' << 'Breeder'
  s.extra_rdoc_files = ["README.md"]

  s.files = %w[
    VERSION
    LICENSE.txt
    CHANGELOG.rdoc
    README.md
    Rakefile
  ] + Dir['lib/**/*.rb']

  s.test_files = Dir['spec/*.rb']
end
