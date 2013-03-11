require 'radix/numeric'

module Radix

  # Radix::Float is simple a Ruby Float class that can handle bases.
  #
  # TODO: Make fully immutable. After that we can catch @digits and
  # the library should be a good bit faster.
  class Float < Numeric

    # Internal floating point value.
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

    #
    def to_i
      to_f.to_i
    end

    #
    alias_method :to_int, :to_i

    #
    def to_f
      value.to_f
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
      i, f = base_conversion(value, base)
      if negative?
        ['-'] + i + [DOT] + f
      else
        i + [DOT] + f
      end
    end

    #
    def digits_encoded
      base_encode(digits)
    end

    # Returns true if the number negative?
    def negative?
      value < 0
    end

    #
    def convert(new_base)
      self.class.new(value, new_base)
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

    #
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

    #
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

    #
    def split_float(float)
      i, f = float.to_s.split('.')
      return i.to_i, ('0.'+f).to_f
    end

  end

end

