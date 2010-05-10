module Radix

  class Number < Numeric

    attr :value

    attr :base

    def initialize(value, base)
      @value = value
      @base  = base
    end

    def +(other)
    end

    def -(other)
    end

    def *(other)
    end

    def /(other)
    end

  private

    def operation(op, other)
      case other
      when Radix::Number
        # covert other to present base
        o = Radix.convert(other, other.base, self.base)
      else

      end


  end

end
