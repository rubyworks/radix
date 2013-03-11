require 'radix/base'

# @author Thomas Sawyer
module Radix

  # Radix separator used in string and array representations.
  DOT = '.'

  # Division character for rational numbers
  DIV = '/'

  # Default seperator character.
  DIVIDER = " "

  # Radix::Numeric class inherits from Ruby's Numeric class. It is then
  # subclassed by Radix::Integer and Radix::Float.
  #
  # @todo Make immutable, but best way to do it?
  # @example First suggestion
  #   class << self
  #     alias_method :_new, :new
  #     private :_new
  #   end
  # @example Second suggestion
  #   def self.new(value, base=10)
  #     @cache ||= {}
  #     @cache[[value, base]] ||= _new(value, base)
  #   end
  class Numeric < ::Numeric

    # Addition: binary operation
    # @param [Radix::Numeric] other
    # @return [Radix::Numeric] Result of arithmetic operation.
    def +(other)
      operation(:+, other)
    end

    # Subtraction: binary operation
    # @param [Radix::Numeric] other
    # @return [Radix::Numeric] Result of arithmetic operation.
    def -(other)
      operation(:-, other)
    end

    # Multiplication: binary operation
    # @param [Radix::Numeric] other
    # @return [Radix::Numeric] Result of arithmetic operation.
    def *(other)
      operation(:*, other)
    end

    # Division: binary operation
    # @param [Radix::Numeric] other
    # @return [Radix::Numeric] Result of arithmetic operation.
    def /(other)
      operation(:/, other)
    end

    private

    ##
    # Parses the value of the base and character set to use.
    #
    # @param [Array<String>, Fixnum] base The value of the base, or a set of
    #   characters to use as representation of the base.
    # @note If an array of String characters is passed, its length is the
    #   value of the base level.
    # @return [Array<(Fixnum, [Array<String>, nil])>] Two part array:
    #   0 - Fixnum value of the base.
    #   1 - Nil, or Array of characters representing the base values.
    def parse_base(base)
      case base
       when Array
        code = base
        base = base.size
      else
        code = nil
        base = base
      end
      return base, code
    end

    ##
    # Simply returns the passed value. Used for simplifying creation of Radix
    # instances.
    # 
    # @param [Radix::Float, Radix::Integer] value Given value.
    # @param [String, Array, Numeric] base Desired base.
    def parse_numeric(value, base)
      value
    end

    # If a float style string is passed in for +value+, e.g. "9.5", the
    # decimal will simply be truncated. So "9.x" would become "9".
    def parse_string(value, base)
      digits = value.split(//)
      parse_array(digits, base)
    end

    # Take an Array in the form of [d1, d2, ..., DOT, d-1, d-2, ...]
    # and convert it to base ten, and store in @value.

    def parse_array(value, base)
      value = value.dup

      if value.first == '-'
        neg = true
        value.shift
      else
        neg = false
      end

      value = base_decode(value)

      ## raise an error if any digit is not less than base
      raise ArgumentError if value.any?{ |e| ::Numeric === e && base < e }

      v = decimal(value, base)

      neg ? -v : v
    end

    # Convert array of values of a different base to decimal.
    # This handles integer values. The method for Radix::Float
    # is slighly different.
    def decimal(digits, base)
      e = digits.size - 1
      v = 0
      digits.each do |n|
        v += n.to_i * base**e
        e -= 1
      end
      v
    end

    # Map array of values to base encoding. If no encoding is defined
    # this simply returns the +digits+ unchanged.
    def base_encode(digits)
      return digits unless @code
      digits.map do |i|
        case i
        when '-', DOT, DIV
          i
        else
          code[i]
        end
      end
    end

    # Decode an encoded array.
    def base_decode(digits)
      #return digits unless code
      code = self.code || BASE::B62
      digits.map do |c|
        case c
        when '-', DOT, DIV
          c
        when ::Numeric
          c
        else
          code.index(c)  # TODO: Could speed up with an reverse index.
        end
      end
    end

  end

end
