require 'rational'
require 'radix/numeric'

module Radix

  # Represents rational numbers.
  #
  class Rational < Numeric

    # Alternative to #new.
    def self.[](n,d=nil,b=10)
      new(n,d,b)
    end

    # Stores the Rational value.
    attr :value

    # Base of the number.
    attr :base

    # Base encoding table.
    attr :code

    private

    # Create a new Radix::Rational instance.
    #
    #   Rational.new(<Integer>, <Integer>, <Integer>)
    #   Rational.new(<Rational>, <Integer>)
    #
    def initialize(numerator, denominator=nil, base=10)
      case numerator
      when ::Rational, Rational
        ratn = numerator
        base = denominator
        @value = Rational(ratn.numerator, ratn.denominator)
      else
        n = parse_value(numerator, base)
        d = parse_value(denominator, base)
        @value = Rational(n, d)
      end
      @base, @code = parse_base(base)
    end

    #
    def parse_value(value, base)
      case value
      when Float, Integer # Radix
        parse_numeric(value.to_i, base)
      when ::Array
        parse_array(value, base)
      when ::String
        parse_string(value, base)
      when ::Numeric
        parse_numeric(value.to_i, base)
      end
    end

    public

    # The numerator.
    #
    def numerator
      @value.numerator
    end

    # The denominator.
    #
    def denominator
      @value.denominator
    end

    # Is the value negative?
    #
    def negative?
      value < 0
    end

    # Convert rational to new base.
    #
    # Returns new rational. [Radix::Rational]
    def convert(base)
      self.class.new(numerator, denominator, base)
    end

    # Convert to rational.
    #
    # Returns the internal value. [Rational]
    def to_r
      value
    end

    # Convert to Float by dividing the numerator by the denominator.
    #
    # Returns the converted value. [Float]
    def to_f
      numerator.to_f / denominator.to_f
    end

    # Convert to Integer by converting to Float first then
    # appling #to_i to the float.
    #
    # Returns the converted value. [Integer]
    def to_i
      to_f.to_i
    end

    # Translate value into an array of places.
    #
    # Returns array of places. [Array]
    def to_a(base=nil)
      if base
        convert(base).digits_encoded
      else
        digits_encoded
      end     
    end

    # Convert the value into a string representation of the given base.
    #
    # base    - the base to convert
    # divider - symbol to used ot divide numbers
    #
    # Returns translated value. [String]
    def to_s(base=nil, divider=nil)
      divider = divider.to_s if divider
      if base
        convert(base).to_s(nil, divider)
      else
        if code
          digits_encoded.join(divider)
        else
          if @base > 10
            digits.join(divider || DIVIDER)
          else
            digits.join(divider)
          end
        end
      end
    end

    # Are two rationals equal?
    #
    # TODO: this may need improvement to be more percise.
    #
    # Returns true if equal, otherwise false. [Boolean]
    def ==(other)
      a, b = self.to_f, other.to_f
      a == b
    end

    #
    def reduce
      self.class.new(Rational(numerator, denominator), base)
    end

    #
    def digits
      n = base_conversion(numerator, base)
      d = base_conversion(denominator, base)
      i = n + ['/'] + d
      i.unshift('-') if negative? 
      i
    end

    #
    def digits_encoded
      base_encode(digits)
    end

    # Returns [String]
    def inspect
      "#{digits.join(' ')} (#{base})"
    end

    #
    def coerce(value)
      [Radix::Rational.new(value), self]  
    end

    private

    # Perform operation.
    #
    # Returns new rational. [Radix::Rational]
    def operation(op, other)
      x = value.__send__(op, other.to_r)
      self.class.new(x, base)
    end

    # Perform base conversion.
    #
    # Returns array of places. [Array]
    def base_conversion(value, base)
      #if value < 0
      #  @negative, value = true, value.abs
      #end
      i = value.abs

      a = []
      while i > 0
        i, r = i.divmod(base)
        a << r
      end

      a << 0 if a.empty?

      a.reverse
    end

  end

end

class ::Array
  # Convenience method for creating a Radix::Rational.
  #
  # TODO: Keep #br? Or find another way?
  #
  # Returns [Radix::Rational]
  def br(base=nil)
    args = dup
    args << base if base
    Radix::Rational.new(*args)
  end
end

if RUBY_VERSION < '1.9'
  class ::Float
    def to_r
      n, f = to_s.split('.')
      d = (10 ** f.size).to_i
      n = (n.to_i * d) + f.to_i
      Rational(n, d) 
    end
  end
end

