require 'radix/numeric'

module Radix

  # Radix::Float is simple a Ruby Float class that can handle bases.
  #
  # TODO: Make fully immutable. After that we can catch @digits and
  # the library should be a good bit faster.
  class Float < Numeric

    # Redix separator used in string and array representations.
    DOT = '.'

    # Internal floating point value.
    attr :value

    # Base of the number.
    attr :base

    private

    #
    def initialize(value, base=10)
      case value
      when Float, Integer # Radix
        initialize_numeric(value.to_f, base)
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

    # Take an Array in the form of [d1, d2, ..., DOT, d-1, d-2, ...]
    # and convert it to base ten, and store in @value.
    def initialize_array(value, base)
      if value.first == '-'
        neg = true
        value.shift
      else
        neg = false
      end
      ## raise an error is any digit is not less than base
      #raise ArgumentError if digits.any?{ |e| base < e }
      i, f = split_array(value)
      e = i.size - 1
      v = 0
      (i + f).each do |n|
        v += n * base**e
        e -= 1
      end
      @value = neg ? -v : v
      @base  = base
    end

    #
    def initialize_string(value, base)
      #if value.start_with?('-')
      #  @negative, value = true, value[1..-1]
      #end
      digits = value.split(//).map do |d|
        case d
        when '-', '.', DOT
          d
        else
          Radix.convert(d, base, 10).to_i
        end
      end
      initialize_array(digits, base)
    end

    public

    #
    def digits
      i, f = base_conversion(value, base)
      if negative?
        ['-'] + i + [DOT] + f
      else
        i + [DOT] + f
      end
    end

    # Returns true if the number negative?
    def negative?
      value < 0
    end

    #
    def convert(new_base)
      self.class.new(value, new_base)
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

    #
    alias_method :modulo, :%

    #
    def abs
      self.class.new(value.abs, base)
    end

    #
    def ceil
      self.class.new(value.ceil, base)
    end

    #
    def floor
      self.class.new(value.floor, base)
    end

    #
    def round
      return self.class.new((value + 0.5).floor, base) if self > 0.0
      return self.class.new((value - 0.5).ceil,  base) if self < 0.0
      return self.class.new(0, base)
    end

    # Strict equality requires same class as well as value.
    def eql?(num)
      self.class.equal?(num.class) && self == num
    end

    # Simple equality requires equal values only.
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

    #
    def to_i
      to_f.to_i
    end

    #
    alias_method :to_int, :to_i

    #
    def to_f
      value.to_f
      #i, f = split_array(digits)
      #e = i.size - 1
      #v = 0
      #(i + f).each do |n|
      #  v += n * base**e
      #  e -= 1
      #end
      #negative ? -v : v
    end

    #
    def inspect
      "#{digits.join(' ')} (#{base})"
    end

    #
    def to_s
      "#{digits.join(' ')} (#{base})"
      #i, f = base_conversion(value, base)
      #(negative? ? '-' : '') + i.join(' ') + '.' + f.join(' ') + "(#{base})"
    end

    #
    def coerce(o)
      [Radix::Float.new(o), self]  
    end

  private

    # Perform arthmetic operation.
    def operation(op, other)
      a = self.to_f
      b = other.to_f
      x = a.__send__(op, b)
      Radix::Float.new(x, base)
    end

    #
    def base_conversion(value, base)
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
      p = 20
      b = []
      while !f.zero?
        k = (f * base)
        r, f = split_float(k)
        #c.include?(f) ? break : c << f
        break if p == 0; p -= 1
        b << r
      end

      b << 0 if b.empty?

      [a.reverse, b]
    end

    #
    def split_array(value)
      if d = value.index(DOT) || value.index('.')
        i, f = value[0...d], value[d+1..-1]
      else
        i, f = value, [0]
      end
      i.map!{ |x| x.to_i }
      f.map!{ |x| x.to_i }
      return i, f
    end

    #
    def split_float(float)
      i, f = float.to_s.split('.')
      return i.to_i, ('0.'+f).to_f
    end

  end

end

