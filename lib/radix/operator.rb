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

  ##
  # Takes a String and makes it into a Radix::Integer or Radix::Float as given
  # base. Float is determined by a "." character in string instance
  # 
  # @param [Fixnum, Array<String>] base
  #   The desired base.
  #
  # @return [Radix::Integer, Radix::Float]
  def b_with_radix(base = nil)
    # assume this is the ruby String#b being called if base is nil
    return b_without_radix if base.nil? && respond_to?(:b_without_radix)

    if index('.')
      Radix::Float.new(self, base)
    else
      Radix::Integer.new(self, base)
    end
  end

  # String#b in Radix conflicts with String#b in ruby 2.x
  # to get around this without breaking the Radix API
  # we can set up a method chain
  if "".respond_to?(:b)
    alias_method :b_without_radix, :b
    alias_method :b, :b_with_radix
  else
    alias :b :b_with_radix
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

