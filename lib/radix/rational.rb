require 'rational'

module Radix

  #
  class Rational

    # Alternative to #new.
    def self.[](n,d=nil,b=10)
      new(n,d,b)
    end

    #
    #   Rational.new(<Intger>, <Integer>, <Integer>)
    #   Rational.new(<Rational>, <Integer>)
    #
    def initialize(numerator, denominator=nil, base=10)
      case numerator
      when ::Rational, Rational
        ratn = numerator
        base = denominator
        @value = ::Rational.new!(ratn.numerator, ratn.denominator)
      else
        @value = ::Rational.new!(numerator, denominator)
      end
      @base = base
    end

    #
    def value
      @value
    end

    #
    def base
      @base
    end

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
    def +(other)
      operation(:+, other)
    end

    #
    def -(other)
      operation(:-, other)
    end

    #
    def *(other)
      operation(:*, other)
    end

    #
    def /(other)
      operation(:/, other)
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


class Array
  # Convenience method for creating a Radix::Rational.
  # TODO: Keep #br? Or find another way?
  def br(base=nil)
    args = dup
    args << base if base
    Radix::Rational.new(*args)
  end
end


class Float
  #
  def to_r
    n, f = to_s.split('.')
    d = (10 * f.size).to_i
    n = (n.to_i * d) + f.to_i
    Rational(n, d) 
  end
end
