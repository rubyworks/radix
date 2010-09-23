require 'radix/base'

module Radix

  # Radix Numeric base class is subclassed by Radix::Integer and Radix::Float,
  # and is a subclass of Ruby's built-in Numeric class.
  #
  # NOTE: At this point this looks to be unneccessary, but we will
  # keep it for the time being, just in case it proves useful.
  #
  # TODO: Handle floating point numbers.
  class Numeric < ::Numeric
  end

end
