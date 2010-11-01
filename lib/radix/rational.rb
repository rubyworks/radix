require 'rational'
require 'radix/numeric'

module Radix

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
        @value = ::Rational.new!(ratn.numerator, ratn.denominator)
      else
        n = parse_value(numerator, base)
        d = parse_value(denominator, base)
        @value = ::Rational.new!(n, d)
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

    #
    def numerator
      @value.numerator
    end

    #
    def denominator
      @value.denominator
    end

    #
    def negative?
      value < 0
    end

    #
    def convert(base)
      self.class.new(numerator, denominator, base)
    end

    #
    def to_r
      value
    end

    #
    def to_f
      numerator.to_f / denominator.to_f
    end

    #
    def to_i
      to_f.to_i
    end

    #
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
      i = n + [':'] + d
      i.unshift('-') if negative? 
      i
    end

    #
    def inspect
      "#{digits.join(' ')} (#{base})"
    end

    #
    def to_s
      "#{digits.join(' ')} (#{base})"
    end

    #
    def coerce(value)
      [Radix::Rational.new(value), self]  
    end

    private

    #
    def operation(op, other)
      x = value.__send__(op, other.to_r)
      self.class.new(x, base)
    end

    #
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

      a.reverse
    end

  end

end

class ::Array
  # Convenience method for creating a Radix::Rational.
  # TODO: Keep #br? Or find another way?
  def br(base=nil)
    args = dup
    args << base if base
    Radix::Rational.new(*args)
  end
end

class ::Float
  #
  def to_r
    n, f = to_s.split('.')
    d = (10 * f.size).to_i
    n = (n.to_i * d) + f.to_i
    Rational(n, d) 
  end
end
