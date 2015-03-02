# This script defines the `#b` core extension method for Ruby's built-in
# Numeric classes to make it easy to convert to Radix base classes.

##
# Adds the b(base) method to this ruby class for quickly creating Radix
# instances.
class ::Float

  ##
  # Takes a Ruby Float and makes it into a Radix::Float as given base.
  # 
  # @param [Fixnum, Array<String>] base
  #   The desired base.
  #
  # @return [Radix::Float]
  def b(base)
    Radix::Float.new(self, base)
  end
end

##
# Adds the b(base) method to this ruby class for quickly creating Radix
# instances.
class ::Integer

  ##
  # Takes a Ruby Integer and makes it into a Radix::Integer as given base.
  # 
  # @param [Fixnum, Array<String>] base
  #   The desired base.
  #
  # @return [Radix::Integer]
  def b(base)
    Radix::Integer.new(self, base)
  end
end

##
# Adds the b(base) method to this ruby class for quickly creating Radix
# instances.
class ::String

  # Ruby 2.x defines it's own `String#b` method for converting to ASCII 8-bit.
  # That breaks Radix (of course), but it a terrbile name. `String#ascii` is 
  # much better (duh!). So that's what we are doing.
  if method_defined?(:b)
    alias :ascii :b
  else
    def ascii
      force_encoding('ASCII')
    end
  end

  ##
  # Takes a String and makes it into a Radix::Integer or Radix::Float as given
  # base. Float is determined by a "." character in string instance
  # 
  # @param [Fixnum, Array<String>] base
  #   The desired base.
  #
  # @return [Radix::Integer, Radix::Float]
  def b(base=nil)
    return ascii unless base

    if index('.')
      Radix::Float.new(self, base)
    else
      Radix::Integer.new(self, base)
    end
  end
end

##
# Adds the b(base) method to this ruby class for quickly creating Radix
# instances.
class ::Array

  ##
  # Takes array and makes it into a Radix::Integer or Radix::Float as given
  # base. Float is determined by a "." character in array instance.
  # 
  # @param [Fixnum, Array<String>] base
  #   The desired base.
  #
  # @return [Radix::Integer, Radix::Float]
  def b(base)
    if index('.')
      Radix::Float.new(self, base)
    else
      Radix::Integer.new(self, base)
    end
  end

end

