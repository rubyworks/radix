require 'radix/base'
require 'radix/integer'
require 'radix/float'
require 'radix/rational'
require 'radix/operator'

module Radix

  ##
  # Returns the metadata contained in Radix.yml
  #
  # @return [Hash{String=>String}]
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
  #
  # @return [String]
  def self.const_missing(name)
    key = name.to_s.downcase
    metadata.key?(key) ? metadata[key] : super(name)
  end

end

