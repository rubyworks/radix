--- 
name: radix
title: Radix
contact: trans <transfire@gmail.com>
requires: 
- group: 
  - build
  name: syckle
  version: 0+
- group: 
  - test
  name: qed
  version: 0+
resources: 
  repo: git://github.com/rubyworks/radix.git
  code: http://github.com/rubyworks/radix
  mail: http://groups.google.com/group/rubyworks-mailinglist
  home: http://rubyworks.github.com/radix
pom_verison: 1.0.0
manifest: 
- .ruby
- doc/01_synopsis.rdoc
- doc/02_integer.rdoc
- doc/03_float.rdoc
- doc/04_rational.rdoc
- doc/05_base.rdoc
- doc/applique/env.rb
- lib/radix/base.rb
- lib/radix/float.rb
- lib/radix/integer.rb
- lib/radix/numeric.rb
- lib/radix/operator.rb
- lib/radix/rational.rb
- lib/radix.rb
- lib/radix.yml
- spec/02_integer.rdoc
- spec/03_float.rdoc
- spec/04_rational.rdoc
- spec/05_base.rdoc
- spec/applique/env.rb
- HISTORY.rdoc
- LICENSE.txt
- README.rdoc
version: 2.0.0
copyright: Copyright (c) 2009 Thomas Sawyer
licenses: 
- Apache 2.0
description: Convert to and from any base.
organization: RubyWorks
summary: Convert to and from any base.
authors: 
- Thomas Sawyer
created: 2009-07-01
