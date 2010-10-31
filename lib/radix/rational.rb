module Radix

  #
  class Rational

    #
    attr :numerator

    #
    attr :denominator

    #
    attr :base

    #
    def initialize(numerator, denominator, base=10)
      @numerator   = Integer.new(numerator, base)
      @denominator = Integer.new(denominator, base)
      @base        = base
    end

    #
    def convert(base)
      self.class.new(numerator, denominator, base)
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
      n = numerator.to_i
      d = denominator.to_i
      m = n % d
      if m == 0
        @numerator   = Radix::Integer.new((n / d), base)
        @denominator = Radix::Integer.new(1, base)
      end
      self
    end

    #
    def inspect
      numerator.inspect + ' : ' + denominator.inspect
    end

    private

    #
    def operation(op, other)
      a = self.to_f
      b = other.to_f

      x = a.__send__(op, b)

      n, f = x.to_s.split('.')

      d = (10 * f.size).to_i
      n = (n.to_i * d) + f.to_i

      self.class.new(n, d, base)
    end

  end

end


class Array

  def br(base=nil)
    args = dup
    args << base if base
    Radix::Rational.new(*args)
  end

end

