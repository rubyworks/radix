require 'radix/numeric'

module Radix

  ##
  # Advanced float class for Radix conversions and mathematical operations
  # with other bases. 
  #
  # @todo Make fully immutable. After that we can catch @digits and
  #   the library should be a good bit faster.
  #
  # @!attribute [r] value 
  #   @return [Float] Float's decimal value.
  # @!attribute [r] base
  #   @return [Fixnum] The base level of Float instance.
  # @!attribute [r] code 
  #   @return [Array<String>, nil] Substitution chars or nil if default.
  class Float < Numeric

    ##
    # Internal floating point value.
    #
    # @return [Float] Float's decimal value.
    attr :value

    ##
    # Base of the number.
    #
    # @return [Fixnum] The base level of Float instance.
    attr :base

    ##
    # Base encoding table.
    #
    # @return [Array<String>, nil] Substitution chars or nil if default.
    attr :code

    private

    ##
    # Starts a new instance of the Radix::Float class.
    #
    # @param [Radix::Numeric, Numeric, Array, String] value
    #   The value of the new integer in context of base.
    #
    # @param [Fixnum, Array<String>] base
    #   The base context in which value is determined. Can be an array
    #   of characters to use in place of default.
    #
    # @return [void]    
    def initialize(value, base=10)
      @base, @code = parse_base(base)
      @value = parse_value(value, @base)
    end

    ##
    # Takes a Radix::Numeric, String or array and returns the decimal float
    # value for storage in @value.
    #
    # @param [Radix::Numeric, Numeric, String, Array<Numeric, String>] value
    #   The value of the integer in base context.
    #
    # @param [Fixnum, Array<String>] base
    #   The context base of value.
    #
    # @return [Float] Float value of Integer.
    def parse_value(value, base)
      case value
      when Float, Integer # Radix
        parse_numeric(value.to_f, base)
      when ::Array
        parse_array(value, base)
      when ::String
        parse_string(value, base)
      when ::Numeric
        parse_numeric(value.to_f, base)
      end
    end

  public

    ##
    # Convert the Radix::Float a Ruby Integer.
    # 
    # @return [Integer] Base(10) value as Integer.
    def to_i
      to_f.to_i
    end

    alias_method :to_int, :to_i

    ##
    # Convert Radix::Float to a Ruby float.
    # 
    # @return [Float] Base(10) value as Float.
    def to_f
      value.to_f
    end

    ##
    # Makes this Radix::Float an array using code if defined. Returns an
    # array using default chars otherwise. 
    #
    # @param [Fixnum] base
    #   Desired base.
    #
    # @return [Array<Fixnum, String>] Current base encoded array.
    def to_a(base=nil)
      if base
        convert(base).digits_encoded
      else
        digits_encoded
      end
    end

    ##
    # Creates an encoded string in passed base, with passed digit divider.
    #
    # @note For base 10 or less does not use a divider unless specified.
    #
    # @param [Fixnum, Array<String>] base
    #   Desired base.
    #
    # @param [String] divider
    #   Desired divider character(s).
    #
    # @return [String] Encoded string with specified divider.
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
    # Creates a string representation of self.
    #
    # @return [String] String rep of self.digits and @base.
    def inspect
      "#{digits.join(' ')} (#{base})"
    end

    ##
    # Returns an array representation of each column's value in decimal chars.
    #
    # @return [Array<String, Fixnum>]
    #   Values per column of @base as array. Prepended with "-" if negative. 
    def digits
      i, f = base_conversion(value, base)
      if negative?
        ['-'] + i + [DOT] + f
      else
        i + [DOT] + f
      end
    end

    ##
    # Returns digits, or coded version of digits if @code.
    #
    # @return [Array<String, Fixnum>]
    #   Values per column of @base as array. Prepended with "-" if negative.
    #   Or encoded version if @code is defined.
    def digits_encoded
      base_encode(digits)
    end

    ##
    # Returns true if the number is negative?
    #
    # @return [Boolean] True if float value is < 0.
    def negative?
      value < 0
    end

    ## 
    # Creates a new Radix::Float of same value in different base.
    #
    # @return [Radix::Float] New float of same value in different base.
    def convert(new_base)
      self.class.new(value, new_base)
    end

    ##
    # Power exponentional operation.
    #
    # @param [#to_f] other
    #   The exponent by which to raise Float.
    #
    # @return [Radix::Float] Result of exponential operation.
    def **(other)
      operation(:**, other)
    end

    ##
    # Modulo binary operation.
    #
    # @param [#to_f] other
    #
    # @return [Radix::Float] Modulo result of division operation.
    def %(other)
      operation(:%, other)
    end

    alias_method :modulo, :%

    ##
    # Returns the absolute value of self in @base.
    #
    # @return [Radix::Float] Absolute of @value.
    def abs
      self.class.new(value.abs, base)
    end

    ##
    # Returns the largest integer greater than or equal to self as a
    # Radix::Float.
    #
    # @return [Radix::Float] 
    def ceil
      self.class.new(value.ceil, base)
    end

    ##
    # Returns the smallest integer less than or equal to self as a
    # Radix::Float.
    #
    # @return [Radix::Float] 
    def floor
      self.class.new(value.floor, base)
    end

    ##
    # Returns a new Radix::Float instance of same base, rounded to the nearest 
    # whole integer.
    # 
    # @example Rounding Radix Float
    #   > round_test = Radix::Float.new(123.03, 16)
    #   7 11 . 0 7 10 14 1 4 7 10 14 1 (16)
    #   > round_test.value
    #   123.03
    #   > round_test.round
    #   7 11 . 0 (16)
    #   > round_test.round.value
    #   123.0
    #   > round_test += 0.5
    #   7 11 . 8 7 10 14 1 4 7 10 14 1 (16)
    #   > round_test.value
    #   123.53
    #   > round_test.round
    #   7 12 . 0 (16)
    #   > round_test.round.value
    #   124.0
    #
    # @return [Radix::Float] New Instance
    def round
      return self.class.new((value + 0.5).floor, base) if self > 0.0
      return self.class.new((value - 0.5).ceil,  base) if self < 0.0
      return self.class.new(0, base)
    end

    ##
    # Strict equality requires same class as well as value.
    #
    # @param [Object] num
    #   Object to compare.
    #
    # @return [Boolean] True if class and value are equal.
    def eql?(num)
      self.class.equal?(num.class) && self == num
    end

    ##
    # Simple equality requires equal values only.
    #
    # @param [Numeric] other
    #   Any Numeric instance.
    #
    # @return [Boolean] True if values are equal.
     def ==(other)
      case other
      when Float, Integer  # Radix
        value == other.value
      else
        value == other
      end
    end

    ##
    # Comparitive binary operation. Very useful for sorting methods.
    # 
    # @param [#to_f] other
    #   The object to compare value against.
    #
    # @example Comparison testing
    #   > lower = Radix::Float.new(123.00,10)
    #   1 2 3 . 0 (10)
    #   > higher = Radix::Float.new(456.00,16)
    #   1 12 8 . 0 (16)
    #   > lower <=> higher
    #   -1
    #   > lower <=> 123
    #   0
    #   > lower <=> "123"
    #   0
    #   > higher <=> lower
    #   1
    #
    # @return [Fixnum] Returns -1 for less than, 0 for equal or 1 for more than.
    def <=>(other)
      to_f <=> other.to_f
    end

    #
    #def infinite?
    #  digits[0,2] == [0, DOT]
    #end

    #
    #def finite?
    #  !infinite
    #end

    #
    #def nan?
    #  digits[-2,2] == [DOT, 0]
    #end

    ##
    # Create a new Radix::Float from value in Base-10.
    # 
    # @param [Numeric, Array, String] other
    #   The value of the new integer in base-10.
    #
    # @return [Array<Radix::Float>] An array of the new Float object and self.
    def coerce(other)
      [Radix::Float.new(other), self]  
    end

    private

    ##
    # Perform passed arithmetic operation.
    #
    # @param [#to_f] other
    #
    # @return [Radix::Float] Result of binary operation in @base.
    def operation(op, other)
      a = self.to_f
      b = other.to_f
      x = a.__send__(op, b)
      Radix::Float.new(x, base)

    end

    ##
    # Returns two arrays. The integer part and the fractional part of the Float
    # value in param base.
    #
    # @param [Float] value  Float's decimal value.
    # @param [Fixnum] base  The base level of Float instance.
    # @param [Fixnum] prec  The # of places to extend F-part.
    #
    # @return [Array<(Array[Fixnum], Array[Fixnum])>] 
    def base_conversion(value, base, prec=10)
      #if value < 0
      #  @negative, value = true, value.abs
      #end
      value = value.to_f.abs

      i, f = split_float(value)

      a = []
      while i > 0
        i, r = i.divmod(base)
        a << r
      end

      #c = [] # f-cache 
      p = prec
      b = []
      while !f.zero?
        k = (f * base)
        r, f = split_float(k)
        #c.include?(f) ? break : c << f
        break if p == 0; p -= 1
        b << r
      end

      a << 0 if a.empty?
      b << 0 if b.empty?

      [a.reverse, b]
    end

    ##
    # Convert array of values of a different base to decimal as called by
    # parse_array.
    #
    # @param [Array<Numeric, String>] digits  Representation of Base values.
    # @param [Fixnum, Array<String>] base  The base to convert from.
    #
    # @return [Float] The digits of base converted to decimal.
    def decimal(digits, base)
      i, f = split_digits(digits)
      e = i.size - 1
      v = 0
      (i + f).each do |n|
        v += n * base**e
        e -= 1
      end
      v
    end

    ##
    # Returns the I-Part and F-Part of the passed value as arrays of fixnums.
    # 
    # @param [Array<Numeric, String>] value
    #   The array of decimal values per column of @base.
    #
    # @return [Array<(Array<Fixnum>, Array<Fixnum>)>]
    def split_digits(value)
      if d = value.index(DOT) || value.index('.')
        i, f = value[0...d], value[d+1..-1]
      else
        i, f = value, [0]
      end
      i.map!{ |x| x.to_i }
      f.map!{ |x| x.to_i }
      return i, f
    end

    ##
    # Returns an array of Integer and Float portions of the Radix::Float
    #
    # @param [Radix::Float] float  Float value to split
    #
    # @return [Array<(Integer, Float)>]
    def split_float(float)
      i, f = float.to_s.split('.')
      return i.to_i, ('0.'+f).to_f
    end

  end

end

