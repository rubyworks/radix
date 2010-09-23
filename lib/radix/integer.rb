require 'radix/numeric'

module Radix

  # TODO: Handle negative/signed numbers.
  class Integer < Numeric

    #
    attr :digits

    # Base of the number.
    attr :base

    #
    def initialize(value, base=10)
      case value
      when ::Array
        @digits = value
      when ::String
        @digits = value.to_s.split(//).map{ |e| Radix.convert(e, base, 10).to_i }
      when ::Numeric
        @digits = value.to_s.split(//).map{ |e| e.to_i }
      end
      @base = base
    end

    #
    def convert(new_base)
      new_digits = Radix::Base.convert_base(digits, base, new_base)
      self.class.new(new_digits, new_base)
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

    # Asymmetric binary shift operator.
    def <<(o)
      Radix::Integer.new(to_int << o.to_int, base)
    end

    # AND bit operator
    def &(o)
      Radix::Integer.new(to_int & o.to_int, base)
    end

    #
    def eql?(num)
      self.class.equal?(num.class) && self == num
    end

    #
    def ==(other)
      case other
      when Radix::Integer
        if base == other.base
          digits == other.digits
        else
          digits == other.convert(base).digits
        end
      else
        self == Radix::Integer.new(other)
      end
    end

    #
    def <=>(other)
      to_i <=> other.to_i
    end

    #
    def to_i
      convert(10).to_i
    end

    #
    alias_method :to_int, :to_i

    #
    def to_s
      "#{digits.join(' ')}(#{base})"
    end

    #
    def coerce(o)  
      [Radix::Integer.new(o), self]  
    end

  private

    def operation(op, other)
      case other
      when Radix::Integer
        s = Radix::Base.convert_base(self.digits , self.base , 10)
        o = Radix::Base.convert_base(other.digits, other.base, 10)

        s = s.join.to_i
        o = o.join.to_i

        r = s.__send__(op, o)

        r = r.to_s.split(//).map{ |e| e.to_i }

        n = Radix::Base.convert_base(r, 10, self.base)

        Radix::Integer.new(n, self.base)
      else

      end
    end

  end

end
