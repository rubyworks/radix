# Radix

[![Gem Version](https://img.shields.io/gem/v/radix.svg?style=flat)](https://rubygems.org/gems/radix)
[![CI](https://github.com/rubyworks/radix/actions/workflows/ci.yml/badge.svg)](https://github.com/rubyworks/radix/actions/workflows/ci.yml)

<b>[Radix](https://rubyworks.github.io/radix) is a very easy to use Ruby library
for converting numbers to and from any base. It supports Integer, Float and
Rational numbers, as well as representational string-notations that need not be
in ASCII order.</b>


## Features

* Convert to and from any base.
* Convert Integer, Float and Rational numbers.
* Define custom encodings and character sets.
* Can be used to encode/decode bytecode strings.
* Very intuitive API.


## Usage

Base conversions with ASCII ordered notations are easy in Ruby.

```ruby
255.to_s(16)   #=> "ff"

"FF".to_i(16)  #=> 255
```

But Ruby reaches its limit at base 36.

```ruby
255.to_s(37)   #=> ArgumentError
```

Radix provides the means of converting to and from any base.

For example, a number in base 256 can be represented by the array `[100, 10]`
(`100*256 + 10`) and can be converted to base 10.

```ruby
[100,10].b(256).to_a(10)  #=> [2,5,6,1,0]
```

Or, to get a string representation for any base.

```ruby
[100,10].b(256).to_s(10)  #=> "25610"
```

A string representation of a number can be converted too.

```ruby
"10".b(62).to_s(10)  #=> "62"
```

To use a custom character set, use an array of characters as the base
rather than an integer. For example we can convert a base 10 number
to another base 10 number using a different encoding.

```ruby
base = [:Q, :W, :E, :R, :T, :Y, :U, :I, :O, :P]

"10".b(10).to_a(base)  #=> [:W, :Q]
```

To learn more have a look at the [demos](demo/), which are also Radix's
tests.

### Ruby's own `String#b`

Ruby has a `String#b` method of its own, which returns a copy of a string in
ASCII-8BIT encoding. Radix's `#b` takes a base; called without one, on a
string, it is still Ruby's method. If you would rather not use the core
extensions, the classes can be used directly:

```ruby
Radix::Integer.new("10", 62).to_s(10)  #=> "62"
```


## Installing

Radix needs Ruby 2.7 or later. With Bundler, add it to your project's Gemfile:

    gem 'radix'

Or install it with RubyGems:

    $ gem install radix


## Special Thanks

Special thanks to **douglascodes** for taking the time to fully document
Radix's API. Documentation is an under-addressed and time-consuming affair,
so your contribution is greatly appreciated. Thank you, Douglas!


## Copyrights

Copyright (c) 2009 [Rubyworks](https://rubyworks.github.io)

This program is distributable in accordance with the *BSD-2-Clause* license.

See LICENSE.txt for details.

