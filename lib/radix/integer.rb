require 'radix/numeric'

module Radix

  #
  class Integer < Numeric

    # Stores the numerc value as normal number.
    attr :value

    # Base of the number.
    attr :base

    # Base encoding table.
    attr :code

    private

    #
    def initialize(value, base=10)
      @value = parse_value(value, base)
      @base, @code = parse_base(base)
    end

    #
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

    # Take an Array in the form of [..., d2, d1, d0] and convert it to
    # base ten, and store in @value.
    #
    # If a float style array is passed in for +value+, e.g. [9, '.', 5],
    # the fractional part will simply be truncated.
    def initialize_array(value, base)
      if i = value.index(DOT)
        value = [0...i]
      end
      super(value, base)
    end

    ## digits << #Radix.convert(d, base, 10).to_i

    public

    #
    def to_i
      value.to_i #(sign + convert(10).digits.join('')).to_i
    end

    #
    alias_method :to_int, :to_i

    #
    def to_f
      value.to_f #(sign + convert(10).digits.join('')).to_f
    end

    #
    def to_a(base=nil)
      if base
        convert(base).digits_encoded
      else
        digits_encoded
      end
    end

    #
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

    #
    def inspect
      "#{digits.join(' ')} (#{base})"
    end

    #
    def digits
      i = base_conversion(value, base)
      i.unshift('-') if negative?
      i
    end

    #
    def digits_encoded
      base_encode(digits)
    end

    # Returns true if the number is negative.
    def negative?
      value < 0
    end

    #
    def convert(base)
      self.class.new(value, base)
      #new_digits = Radix::Base.convert_base(digits, base, new_base)
      #self.class.new(new_digits, new_base)
    end

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

    # Power
    def **(other)
      operation(:**, other)
    end

    # Modulo
    def %(other)
      operation(:%, other)
    end

    # Asymmetric binary shift operator.
    def <<(o)
      Radix::Integer.new(to_int << o.to_int, base)
    end

    # AND bit operator
    def &(o)
      Radix::Integer.new(to_int & o.to_int, base)
    end

    #
    def abs
      self.class.new(value.abs, base)
    end

    # Strict equality requires same class as well as value.
    def eql?(num)
      self.class.equal?(num.class) && self == num
    end

    # Simple equality requires equal values only.
    # TODO: Handle Float and Radix::Float.
    def ==(other)
      case other
      when Float, Integer  # Radix
        value == other.value
      else
        value == other
      end
    end

    #
    def <=>(other)
      value <=> other.to_f  # to_num
    end

    #
    def coerce(value)
      [Radix::Integer.new(value), self]  
    end

    private

    # Perform arthmetic operation.
    def operation(op, other)
      a = self.to_i
      b = other.to_i
      x = a.__send__(op, b)
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
