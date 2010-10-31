require 'radix/numeric'

module Radix

  #
  class Integer < Numeric

    DOT = '.'

    #
    attr :value

    # Base of the number.
    attr :base

    ; ; ; private ; ; ;

    #
    def initialize(value, base=10)
      case value
      when Integer, Float # Radix
        initialize_numeric(value.to_i, base)
      when ::Array
        initialize_array(value, base)
      when ::String
        initialize_string(value, base)
      when ::Numeric
        initialize_numeric(value, base)
      end
    end

    #
    def initialize_numeric(value, base)
      @value = value
      @base  = base
    end

    # Take an Array in the form of [..., d2, d1, d0]
    # and convert it to base ten, and store in @value.
    def initialize_array(value, base)
      if i = value.index(DOT)
        value = [0...i]
      end
      if value.first == '-'
        neg = true
        value.shift
      else
        neg = false
      end
      #i, f = split_array(value)
      e = value.size - 1
      v = 0
      value.each do |n|
        v += n.to_i * base**e
        e -= 1
      end
      @value = neg ? -v : v
      @base  = base
    end

    # If a float style string is passed in for +value+, e.g. "9.5", the
    # decimal will simply be truncated. So "9.x" would become "9".
    def initialize_string(value, base)
      #if value.start_with?('-')
      #  @negative, value = true, value[1..-1]
      #end
      digits = []
      value.split(//).each do |d|
        case d
        when DOT
          break
        when '-'
          digits << d
        else
          digits << Radix.convert(d, base, 10).to_i
        end
      end
      initialize_array(digits, base)
    end

    ; ; ; public ; ; ;

    #
    def digits
      i = base_conversion(value, base)
      i.unshift('-') if negative?
      i
    end

    # Returns true if the number is negative.
    def negative?
      value < 0
    end

    #
    def convert(new_base)
      self.class.new(value, new_base)
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
    def to_i
      value.to_i #(sign + convert(10).digits.join('')).to_i
    end

    #
    def to_f
      value.to_f #(sign + convert(10).digits.join('')).to_f
    end

    #
    alias_method :to_int, :to_i

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
      [Radix::Integer.new(value), self]  
    end

    ; ; ; private ; ; ;

    # Perform arthmetic operation.
    def operation(op, other)
      a = self.to_i
      b = other.to_i
      x = a.__send__(op, b)
      Radix::Integer.new(x, base)
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
