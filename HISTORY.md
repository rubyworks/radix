# RELEASE HISTORY

## 2.0.2 / 2013-01-31

This release simple updates the build a bit, primarily converting RDoc
documents to Markdown.

Changes:

* Convert RDoc documents to Markdown.
* Various minor administrative chores.


## 2.0.1 / 2011-10-23

This release is simply an adminstrative release to update the project
build configuration. The functionality of the library itself has not
changed. This release also transitions the project to the BSD-2-Clause
license.

Changes:

* Modernize build configuration.
* Switch to BSD-2-Clause license.


## 2.0.0 / 2010-10-31

Radix::Number has been deprecate in favor of three separate classes,
Radix::Integer, Radix::Float and Radix::Rational. In addition
implementation of these classes has been reworked.

Changes:

* Deprecate Radix::Number
* Add Radix::Integer
* Add Radix::Float
* Add Radix::Rational


## 1.1.0 / 2010-09-03

Radix now provides an actual Numeric subclass, Radix::Number, that stores
the base and can be used like any other Numeric object. This makes it very
easy to convert and manipulate numbers in any base. The implementation is still
a bit nascent. For the moment, it only supports the most basic math operators
and only handles integer values, but furture releases will continue to expand
on it's capabilites.

Changes:

* Add Radix::Number to handle bases like any other numeric.
* Rename Radix class to Radix::Base.


## 1.0.0 / 2009-07-01

This is the initial stand-alone release of Radix,
ported from the basex.rb library of Ruby Facets.

Changes:

* Happy Birthday!

