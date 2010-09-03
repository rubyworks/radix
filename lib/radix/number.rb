require 'radix/base'

module Radix

  #
  class Number < Numeric

    attr :digits

    attr :base

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

    def +(other)
      operation(:+, other)
    end

    def -(other)
      operation(:-, other)
    end

    def *(other)
      operation(:*, other)
    end

    def /(other)
      operation(:/, other)
    end

    def ==(other)
      case other
      when Radix::Number
        if base == other.base
          digits == other.digits
        else
          digits == other.convert(base).digits
        end
      else
        self == Radix::Number(other)
      end
    end

    #
    def convert(new_base)
      new_digits = Radix::Base.convert_base(digits, base, new_base)
      self.class.new(new_digits, new_base)
    end

  private

    def operation(op, other)
      case other
      when Radix::Number
        s = Radix::Base.convert_base(self.digits , self.base , 10)
        o = Radix::Base.convert_base(other.digits, other.base, 10)

        s = s.join.to_i
        o = o.join.to_i

        r = s.__send__(op, o)

        r = r.to_s.split(//).map{ |e| e.to_i }

        n = Radix::Base.convert_base(r, 10, self.base)

        Radix::Number.new(n, self.base)
      else

      end
    end

  end

end
