# Radix

[Website](http://rubyworks.github.com/radix) &middot;
[Report Issue](http://github.com/rubyworks/radix/issues) &middot;
[Source Code](http://github.com/rubyworks/radix)

<b>Radix is a very easy to use Ruby library for converting numbers to and from
any base. It supports both Integer, Float and Rational numbers, as well as 
representational string-notations that need not be in ASCII order.</b>


## Status

[![Gem Version](http://img.shields.io/gem/v/radix.svg?style=flat)](http://rubygems.org/gem/radix)
[![Build Status](http://img.shields.io/travis/rubyworks/radix.svg?style=flat)](http://travis-ci.org/rubyworks/radix)
[![Fork Me](http://img.shields.io/badge/scm-github-blue.svg?style=flat)](http://github.com/rubyworks/radix)
[![Report Issue](http://img.shields.io/github/issues/rubyworks/radix.svg?style=flat)](http://github.com/rubyworks/radix/issues)
[![Gittip](http://img.shields.io/badge/gittip-$1/wk-green.svg?style=flat)](https://www.gittip.com/on/github/rubyworks/)
[![Flattr Me](http://api.flattr.com/button/flattr-badge-large.png)](http://flattr.com/thing/324911/Rubyworks-Ruby-Development-Fund)


## Features

* Convert to and from any base.
* Convert Integers, Floats and Rational numbers.
* Define custom encoding and character sets.
* Can be used to encode/decode bytecode strings.
* Very intuitive API.


## Usage

Base conversions with ASCII ordered notations are easy in Ruby.

```ruby
255.to_s(16)   #=> "FF"

"FF".to_i(16)  #=> 255
```

But Ruby reaches it's limit at base 36.

```ruby
255.to_s(37)   #=> Error
```

Radix provides the means of converting to and from any base.

For example, a number in base 256 can be represented by the array `[100, 10]`
(`100**256 + 10**1`) and can be convert to base 10.

```ruby
[100,10].b(256).to_a(10)  #=> [2,5,6,1,0]
```

Or, to get a string representation for any base up to 62.

```ruby
[100,10].b(256).to_s(10)  #=> "25610"
```

A string representation of a number can be converted too, again,
up to base 62.

```ruby
"10".b(62).to_s(10)  #=> "62"
```

To use a custom character set, use an array of characters as the base
rather than an integer. For example we can convert a base 10 number
to another base 10 number using a different encoding.

```ruby
base = [:Q, :W, :E, :R, :T, :Y, :U, :I, :O, :U]

"10".b(10).to_a(base)  #=> [:W, :Q]
```

To learn more have a look at the [QED Demo](http://rubydoc.info/gems/radix/file/DEMO.md).


## Installing

To install with RubyGems simply open a console and type:

    $ gem install radix

Radix follows [Ruby Setup](http://rubyworks.github.com/setup) package standard
so it can also be installed in an FHS compliant manner using setup.rb.


## Special Thanks

Special thanks to **douglascodes** for taking the time to fully document
Radix's API. Documentation is an under-addressed and time-consuming affair,
so your contribution is greatly appreciated. Thank you, Douglas!


## Copyrights

Copyright (c) 2009 Rubyworks

This program is distributable in accordance with the *BSD-2-Clause* license.

See LICENSE.txt for details.

