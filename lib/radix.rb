require 'radix/base'
require 'radix/integer'
require 'radix/float'
require 'radix/rational'  # load ?

module Radix
  #
  def self.metadata
    @metadata ||= (
      require 'yaml'
      YAML.load(File.new(File.dirname(__FILE__) + '/radix.yml'))
    )
  end
  #
  def self.const_missing(name)
    key = name.to_s.downcase
    package[key] || profile[key] || super(name)
  end
end

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

