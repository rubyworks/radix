require_relative 'lib/radix/version'

Gem::Specification.new do |s|
  s.name        = 'radix'
  s.version     = Radix::VERSION
  s.summary     = 'Convert to and from any base.'
  s.description = 'Radix is a very easy to use Ruby library for converting numbers to and from ' \
                  'any base. It supports Integer, Float and Rational numbers, as well as ' \
                  'representational string-notations that need not be in ASCII order.'

  s.authors  = ['Trans']
  s.email    = ['transfire@gmail.com']
  s.homepage = 'https://rubyworks.github.io/radix'
  s.license  = 'BSD-2-Clause'

  s.metadata = {
    'homepage_uri'      => s.homepage,
    'source_code_uri'   => 'https://github.com/rubyworks/radix',
    'bug_tracker_uri'   => 'https://github.com/rubyworks/radix/issues',
    'changelog_uri'     => 'https://github.com/rubyworks/radix/blob/master/HISTORY.md',
    'documentation_uri' => 'https://rubydoc.info/gems/radix'
  }

  s.required_ruby_version = '>= 2.7'

  s.files = Dir[
    'lib/**/*.rb', 'demo/**/*',
    '.yardopts', 'README.md', 'HISTORY.md', 'LICENSE.txt'
  ]
  s.require_paths    = ['lib']
  s.extra_rdoc_files = ['LICENSE.txt', 'HISTORY.md', 'README.md']

  s.add_development_dependency 'rake', '>= 13'
  s.add_development_dependency 'qed', '>= 2.9'
  s.add_development_dependency 'ae', '>= 1.8'
end
