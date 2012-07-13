Gem::Specification.new do |s|
  s.name        = "rspec-profiler"
  s.version     = "1.0.0"
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Michael Blumberg"]
  s.email       = ["mblum14@gmail.com"]
  s.homepage    = "https://github.com/mblum14/rspec-profiler"
  s.summary     = %q{A better formatter for the rspec performance profile}
  s.description = %q{A better formatter for the rspec performance profile}

  s.rubyforge_project = "rspec-profiler"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency('rspec', ["~> 2.0"])
end
