require 'rational'
require 'radix/numeric'

module Radix

  ##
  # Represents rational numbers.
  #
  # @!attribute [r] value
  #   @return [Rational] Ruby Rational representation of self in Base-10.
  # @!attribute [r] base
  #   @return [Fixnum] The base level of Rational instance.
  # @!attribute [r] code 
  #   @return [Array<String>, nil] Substitution chars or nil if default.
  class Rational < Numeric

    ##
    # Alternative to #new.
    #
    # @return [Radix::Rational]
    def self.[](n,d=nil,b=10)
      new(n,d,b)
    end

    ##
    # Stores the Rational value in Base-10.
    #
    # @return [Rational] 
    attr :value

    ##
    # Base of the number.
    #
    # @return [Fixnum] The base level of Rational instance.
    attr :base

    ##
    # Base encoding table.
    #
    # @return [Array<String>, nil] Substitution chars or nil if default.
    attr :code

  private

    ##
    # Create a new Radix::Rational instance.
    # @example
    #   Rational.new(<Integer>, <Integer>, <Integer>)
    #   Rational.new(<Rational>, <Integer>)
    # @param [Radix::Rational, ::Rational, Fixnum] numerator A rational number
    #   or a fixnum for the numerator of a new Rational.
    # @param [Fixnum] denominator Denominator for new Rational.
    # @param [Fixnum] base Base level for new Rational.
    # @return [void]
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

    ##
    # Parses String, Array, Radix::Float, Radix::Integer or Ruby numerics and
    # returns the decimal value from base context for storage in @value.
    # 
    # @param [Fixnum] base 
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

    ##
    # The numerator.
    #
    # @return [Fixnum] The numerator of Radix::Rational
    def numerator
      @value.numerator
    end

    ##
    # The denominator.
    #
    # @return [Fixnum] The denominator of Radix::Rational
    def denominator
      @value.denominator
    end

    ##
    # Is the value negative?
    #
    # @return [Boolean] Returns true if value < 0.
    def negative?
      value < 0
    end

    ##
    # Convert rational to new base.
    #
    # @param [Fixnum] base Desired base.
    # @return [Radix::Rational] Returns new Radix::Rational in passed base.
    def convert(base)
      self.class.new(numerator, denominator, base)
    end

    ##
    # Convert to rational.
    #
    # @return [Rational] Returns the value.
    def to_r
      value
    end

    ##
    # Convert to Float by dividing the numerator by the denominator.
    #
    # Returns the converted value. [Float]
    def to_f
      numerator.to_f / denominator.to_f
    end

    ##
    # Convert to Integer by converting to Float first then
    # appling #to_i to the float.
    #
    # Returns the converted value. [Integer]
    def to_i
      to_f.to_i
    end

    ##
    # Translate value into an array of places. Uses current base unless
    # specified.
    # 
    # @param [Fixnum] base Desired base.
    # @return [Array<Fixnum, String>] Array of place values.
    def to_a(base=nil)
      if base
        convert(base).digits_encoded
      else
        digits_encoded
      end     
    end

    ##
    # Convert the value into a string representation of the given base.
    #
    # @param [Fixnum] base The base to convert.
    # @param [String] divider The string char(s) to divided with.
    # @return [String] Translated value.
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

    ##
    # Simple equality requires equal values only.
    #
    # @todo This may need improvement to be more percise.
    # @param [#to_f] other The value to compare to.
    # @return [Boolean] True if equal values.
    def ==(other)
      a, b = self.to_f, other.to_f
      a == b
    end

    ##
    # Returns an irreducible version of self in current base.
    # 
    # @todo Is this method neccesary since @value is a Ruby Rational and
    #   therefore already irreducible?
    # @return [Radix::Rational]
    def reduce
      self.class.new(Rational(numerator, denominator), base)
    end

    ##
    # Returns an array representation of the numerator and denominator with
    # each column's value.
    #
    # @return [Array<String, Fixnum>] Values per column of @base as array. 
    #   Prepended with "-" if negative. 
    def digits
      n = base_conversion(numerator, base)
      d = base_conversion(denominator, base)
      i = n + ['/'] + d
      i.unshift('-') if negative? 
      i
    end

    ##
    # Returns digits, or coded version of digits if @code.
    #
    # @return [Array<String, Fixnum>] Values per column of @base as array. 
    #   Prepended with "-" if negative. Or encoded version if @code is
    #   defined.
    def digits_encoded
      base_encode(digits)
    end

    ##
    # Creates a string representation of self.
    #
    # @return [String] String rep of self.digits and @base.
    def inspect
      "#{digits.join(' ')} (#{base})"
    end

    ##
    # Returns new Radix::Rational of passed value in base-10 and self as an
    # Array.
    # 
    # @return [Array<(Radix::Rational, Radix::Rational)>]
    def coerce(value)
      [Radix::Rational.new(value), self]  
    end

    private

    ##
    # Perform passed arithmetic operation.
    #
    # @param [#to_r] other  
    # @return [Radix::Rational] Returns the result of the operation in @base.
    def operation(op, other)
      x = value.__send__(op, other.to_r)
      self.class.new(x, base)
    end

    ##
    # Perform base conversion.
    #
    # @return [Array<Fixnum, String>] Array of places.
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
  ##
  # Adds convenience method for creating a Radix::Rational.
  #
  # @todo Keep #br? Or find another way?
  # @return [Radix::Rational]
  def br(base=nil)
    args = dup
    args << base if base
    Radix::Rational.new(*args)
  end
end

if RUBY_VERSION < '1.9'
  class ::Float

    ##
    # Adds a #to_r method to pre-1.9 ruby Rationals.
    # 
    # @return [Rational] 
    def to_r
      n, f = to_s.split('.')
      d = (10 ** f.size).to_i
      n = (n.to_i * d) + f.to_i
      Rational(n, d) 
    end
  end
end

