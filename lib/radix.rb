require 'radix/meta/data'
require 'radix/base'
require 'radix/integer'
require 'radix/float'
require 'radix/rational'  # load ?

class ::Float
  #
  def b(base)
    Radix::Float.new(self, base)
  end
end

class ::Integer
  #
  def b(base)
    Radix::Integer.new(self, base)
  end
end

class ::String
  #
  def b(base)
    if index('.')
      Radix::Float.new(self, base)
    else
      Radix::Integer.new(self, base)
    end
  end
end

class ::Array
  #
  def b(base)
    if index('.')
      Radix::Float.new(self, base)
    else
      Radix::Integer.new(self, base)
    end
  end
end

