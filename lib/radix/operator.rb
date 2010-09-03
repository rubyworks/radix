require 'radix/number'

class ::Numeric

  #
  def b(base)
    Radix::Number.new(self, base)
  end

end


class ::String

  #
  def b(base)
    Radix::Number.new(self, base)
  end

end


class ::Array

  #
  def b(base)
    Radix::Number.new(self, base)
  end

end
