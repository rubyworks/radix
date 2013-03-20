require 'radix/numeric'

module Radix

  ##
  # Advanced integer class for Radix conversions and mathematical operations
  # with other bases. 
  #
  # @!attribute [r] value 
  #   @return [Fixnum] Integer's decimal value.
  # @!attribute [r] base
  #   @return [Fixnum] The base level of Integer instance.
  # @!attribute [r] code 
  #   @return [Array<String>, nil] Substitution chars or nil if default.
  class Integer < Numeric

    ##
    # Stores the numeric value as normal number.
    #
    # @return [Fixnum] Integer's decimal value.
    attr :value

    ##
    # Base of the number.
    #
    # @return [Fixnum] The base level of Integer instance.
    attr :base

    ##
    # Base encoding table.
    #
    # @return [Array<String>, nil] Substitution chars or nil if default.
    attr :code

    private

    ##
    # Starts a new instance of the Radix::Integer class
    #
    # @param [Radix::Integer, Radix::Float, Numeric, Array, String] value The
    #   value of the new integer in context of base.
    # @param [Fixnum, Array<String>] base The base context in which value is
    #   determined. Can be an array of characters to use in place of default.
    # @return [void]
    def initialize(value, base=10)
      @value = parse_value(value, base)
      @base, @code = parse_base(base)
    end

    ##
    # Takes a Radix::Numeric, String or array and returns the decimal value for
    # storage in @value.
    #
    # @param [Radix::Integer, Radix::Float, Numeric, String, Array<Numeric,
    #   String>] value The value of the integer in base context.
    # @param [Fixnum, Array<String>] base The context base of value.
    # @return [Fixnum] Decimal value of Integer.
    def parse_value(value, base)
      case value
      when Integer, Float # Radix
        parse_numeric(value.to_i, base)
      when ::Array
        parse_array(value, base)
      when ::String
        parse_string(value, base)
      when ::Numeric
        parse_numeric(value, base)
      end
    end

    ##
    # Take an Array in the form of [..., d2, d1, d0] and convert it to
    # base ten, and store in @value.
    # @note If a float style array is passed in for +value+, e.g. [9, '.', 5],
    # the fractional part will simply be truncated.
    #
    # @param [Array<String, Numeric>] value Given value.
    # @param [Fixnum, Array<String>] base Desired base.
    # @return [Fixnum] Decimal version of array value in base context.
    def parse_array(value, base)
      if i = value.index(DOT)
        value = [0...i]
      end
      super(value, base)
    end

    ## digits << #Radix.convert(d, base, 10).to_i

    public


    ##
    # Makes this Radix::Integer a ruby integer.
    # 
    # @return [Fixnum] Base(10) value.
    def to_i
      value.to_i #(sign + convert(10).digits.join('')).to_i
    end

    #
    alias_method :to_int, :to_i

    ##
    # Makes this Radix::Integer a ruby float.
    # 
    # @return [Float] Base(10) value as float.
    def to_f
      value.to_f #(sign + convert(10).digits.join('')).to_f
    end

    ##
    # Makes this Radix::Integer an array using code if defined. Returns an
    # array using default chars otherwise.
    #
    # @param [Fixnum] base Desired base.
    # @return [Array<Fixnum, String>] Current base encoded array.
    def to_a(base=nil)
      if base
        convert(base).digits_encoded
      else
        digits_encoded
      end
    end

    ##
    # Creates an encoded string in desired base, with desired digit divider.
    #
    # @param [Fixnum, Array<String>] base Desired base.
    # @param [String] divider Desired divider character(s).
    # @return [String] Encoded string with specified divider.
    # @note For base 10 or less does not use a divider unless specified.
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
    # @return [Array<String, Fixnum>] Values per column of @base as array. 
    #   Prepended with "-" if negative.
    def digits
      i = base_conversion(value, base)
      i.unshift('-') if negative?
      i
    end

    ##
    # Returns the encoded version of digits. 
    #
    # @return [Array<String>] The encoded digits. Or digits if @code exists.
    def digits_encoded
      base_encode(digits)
    end

    ##
    # Returns true if the number is negative.
    #
    # @return [Boolean] True if negative.
    def negative?
      value < 0
    end

    ##
    # Converts Integer to a new base.
    # 
    # @param [Fixnum, Array<String>] base The base context in which value is
    #   determined. Can be an array of characters to use in place of default.
    # @return [Radix:Integer] New Integer of same value, different base.
    def convert(base)
      self.class.new(value, base)
      #new_digits = Radix::Base.convert_base(digits, base, new_base)
      #self.class.new(new_digits, new_base)
    end

    ##
    # Addition: binary operation
    #
    # @param [#to_i] other
    # @return [Radix::Integer] Result of arithmetic operation.
    # @example Which operand determines the base?
    #   > i = Radix::Integer.new(123,16)
    #   7 11 (16)
    #   > i2 = Radix::Integer.new(456,10)
    #   4 5 6 (10)
    #   > i + i2          # i is base 16 and is first operand
    #   2 4 3 (16)        # so base of return is 16
    #   > i2 + i          # i2 is base 10 and is first operand
    #   5 7 9 (10)        # so base of return is 10
    def +(other)
      operation(:+, other)
    end

    ##
    # Subtraction: binary operation
    #
    # @param [#to_i] other
    # @return [Radix::Integer] Result of arithmetic operation.
    def -(other)
      operation(:-, other)
    end

    ##
    # Multiplication: binary operation
    #
    # @param [#to_i] other
    # @return [Radix::Integer] Result of arithmetic operation.
    def *(other)
      operation(:*, other)
    end

    ##
    # Division: binary operation
    #
    # @param [#to_i] other
    # @return [Radix::Integer] Result of arithmetic operation.
    def /(other)
      operation(:/, other)
    end

    ##
    # Power. Exponentional operation.
    #
    # @param [#to_i] other The exponent by which to raise
    #   Integer.
    # @return [Radix::Integer] Result of exponential operation.
    def **(other)
      operation(:**, other)
    end

    ##
    # Modulo: binary operation
    #
    # @param [#to_i] other 
    # @return [Radix::Integer] Modulo result of division operation.
    def %(other)
      operation(:%, other)
    end

    ##
    # Leftwise bit shift operator.
    # @note Negative numbers will shift rightward. This will truncate bytes
    #   that get carried past zero. 
    #
    # @param [#to_int] o The number of places to shift the bits of self.
    # @return [Radix::Integer] The new Radix::Integer with shifted bits.
    def <<(o)
      Radix::Integer.new(to_int << o.to_int, base)
    end

    ##
    # AND bitwise operator
    #
    # @param [#to_i] o 
    # @return [Radix::Integer] The logical AND.
    def &(o)
      Radix::Integer.new(to_int & o.to_int, base)
    end

    ##
    # Returns the absolute value of self in @base.
    #
    # @return [Radix::Integer] Absolute of @value.
    def abs
      self.class.new(value.abs, base)
    end

    ##
    # Strict equality requires same class as well as value.
    #
    # @param [Object] num Test object
    # @return [Boolean] True if class and value are equal.
    def eql?(num)
      self.class.equal?(num.class) && self == num
    end

    ##
    # Simple equality requires equal values only.
    # @todo Handle Float and Radix::Float.
    #
    # @param [#value] other Any object that responds to value.
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
    # @param [#to_f] other The object to compare value against.
    # @return [Fixnum] Returns-1 for less than. 0 for equal. 1 for more than.
    # @example Comparison testing
    #   > lower = Radix::Integer.new(123,10)
    #   1 2 3 (10)
    #   > higher = Radix::Integer.new(456, 16)
    #   1 12 8 (16)
    #   > lower <=> higher
    #   -1
    #   > lower <=> 123
    #   0
    #   > higher <=> lower
    #   1
    def <=>(other)
      value <=> other.to_f  # to_num
    end

    ##
    # Create a new Radix::Integer from value in Base-10
    #
    # @return [Array<Radix::Integer>] An array of the new Integer object and
    #   self.
    def coerce(value)
      [Radix::Integer.new(value), self]  
    end

    private

    ##
    # Perform passed arithmetic operation.
    #
    # @param [#to_i] other  
    # @return [Radix::Integer] Result of binary operation in @base.
    # @example Which operand determines the base?
    #   > i = Radix::Integer.new(123,16)
    #   7 11 (16)
    #   > i2 = Radix::Integer.new(456,10)
    #   4 5 6 (10)
    #   > i + i2          # i is base 16 and is first operand
    #   2 4 3 (16)        # so base of return is 16
    #   > i2 + i          # i2 is base 10 and is first operand
    #   5 7 9 (10)        # so base of return is 10
    def operation(op, other)
      a = self.to_i
      b = other.to_i
      x = a.__send__(op, b)
      self.class.new(x, base)
    end

    ##
    # Returns the value as an array of decimal values where each column is a
    # place of @base.
    # 
    # @param (see #Radix::Integer.value)
    # @param (see #Radix::Integer.base)
    # @return [Array<Fixnum>]
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

      # if nothing add zero
      a << 0 if a.empty?

      a.reverse
    end

  end

end

### Want to see the hard way to do addition?
##
##   def +(other)
##     other = convert_other(other)
##
##     result = []
##     index  = -1
##     carry  = 0
##
##     x1 = self.digits[index]
##     x2 = other.digits[index]
##     while x1 or x2
##       r = (x1||0) + (x2||0) + carry
##       if r >= base
##         result.unshift(r - base)
##         carry = 1
##       else
##         result.unshift(r)
##         carry = 0
##       end
##       index -= 1
##       x1 = self.digits[index]
##       x2 = other.digits[index]
##     end
##     result << carry if carry != 0
##     Radix::Integer.new(result, base)
##   end
##
##   def convert_other(other)
##     case other
##     when Radix::Integer
##       other.convert(base)
##     when Integer
##       Radix::Integer.new(other, base)
##     when String, Array
##       Radix::Integer.new(other, base)
##     end
##   end
##