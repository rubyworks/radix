require 'radix/base'

module Radix

  # Redix separator used in string and array representations.
  DOT = '.'

  #
  DIVIDER = " "

  # Collection of base encodings.
  module BASE
    #
    B12 = ('0'..'9').to_a + ['X', 'E']

    #
    B16 = ('0'..'9').to_a + ('A'..'F').to_a

    #
    B62 = ('0'..'9').to_a + ('A'..'Z').to_a + ('a'..'z').to_a

    # Like BASE16 but encodes with lowercase letters.
    HEX = ('0'..'9').to_a + ('a'..'f').to_a
  end

  # Radix Numeric base class is subclassed by Radix::Integer and Radix::Float,
  # and is a subclass of Ruby's built-in Numeric class.
  class Numeric < ::Numeric

    # Addition
    def +(other)
      operation(:+, other)
    end

    # Subtraction
    def -(other)
      operation(:-, other)
    end

    # Multiplication
    def *(other)
      operation(:*, other)
    end

    # Division
    def /(other)
      operation(:/, other)
    end

    private

    #
    def parse_base(base)
      case base
      when Array
        code = base
        base = base.size
      else
        code = nil
        base = base
      end
      return base, code
    end

    #
    def parse_numeric(value, base)
      value
    end

    # If a float style string is passed in for +value+, e.g. "9.5", the
    # decimal will simply be truncated. So "9.x" would become "9".
    def parse_string(value, base)
      digits = value.split(//)
      parse_array(digits, base)
    end

    # Take an Array in the form of [d1, d2, ..., DOT, d-1, d-2, ...]
    # and convert it to base ten, and store in @value.
    def parse_array(value, base)
      if value.first == '-'
        neg = true
        value.shift
      else
        neg = false
      end

      value = base_decode(value)

      ## raise an error if any digit is not less than base
      raise ArgumentError if value.any?{ |e| ::Numeric === e && base < e }

      v = decimal(value, base)

      neg ? -v : v
    end

    # Convert array of values of a different base to decimal.
    # This handles integer values. The method for Radix::Float
    # is slighly different.
    def decimal(digits, base)
      e = digits.size - 1
      v = 0
      digits.each do |n|
        v += n.to_i * base**e
        e -= 1
      end
      v
    end

    # Map array of values to base encoding. If no encoding is defined
    # this simply returns the +digits+ unchanged.
    def base_encode(digits)
      return digits unless @code
      digits.map do |i|
        case i
        when '-', DOT, '/' #, ':'
          i
        else
          code[i]
        end
      end
    end

    # Decode an encoded array.
    def base_decode(digits)
      #return digits unless code
      code = self.code || BASE::B62
      digits.map do |c|
        case c
        when '/', '.', '-'
          c
        when ::Numeric
          c
        else
          code.index(c)
        end
      end
    end

  end

end
