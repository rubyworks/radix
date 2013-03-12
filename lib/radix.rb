require 'radix/base'
require 'radix/integer'
require 'radix/float'
require 'radix/rational'  # load ?

module Radix

  ##
  # Returns the metadata contained in Radix.yml
  #
  # @return [Hash{String=>String }]
  def self.metadata
    @metadata ||= (
      require 'yaml'
      YAML.load(File.new(File.dirname(__FILE__) + '/radix.yml'))
    )
  end

  ##
  # Gets value of name in metadata or goes up ancestry.
  #
  # @param [Symbol] name
  # @return [String]
  def self.const_missing(name)
    key = name.to_s.downcase
    metadata[key] || super(name)
  end

  # @todo Here only for buggy Ruby 1.8.x.
  VERSION = metadata['version']
end

##
# Adds the b(base) method to this ruby class for quickly creating Radix
# instances.
class ::Float

  ##
  # Takes a Ruby Float and makes it into a Radix::Float as given base.
  # 
  # @param [Fixnum] base The desired base.
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
  # @param [Fixnum] base The desired base.
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
  # @param [Fixnum] base The desired base.
  # @return [Radix::Integer, Radix::Float]
  def b(base)
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
  # @param [Fixnum] base The desired base.
  # @return [Radix::Integer, Radix::Float]
  def b(base)
    if index('.')
      Radix::Float.new(self, base)
    else
      Radix::Integer.new(self, base)
    end
  end
end