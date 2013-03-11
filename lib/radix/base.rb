##
# @author: Thomas Sawyer
module Radix

  ##
  # Collection of base contexts.
  module BASE
    # Array of chars 0 - 9
    B10 = ('0'..'9').to_a
    # Array of chars 0 - 9 + X + E
    B12 = B10 + ['X', 'E']
    # Array of chars 0 - 9 + A - F
    B16 = B10 + ('A'..'F').to_a
    # Array of chars 0 - 9 + A - Z
    B36 = B10 + ('A'..'Z').to_a
    # Array of chars 0 - 9 + A - Z + a - x
    B60 = B36 + ('a'..'x').to_a
    # Array of chars 0 - 9 + A - Z + a - z
    B62 = B36 + ('a'..'z').to_a
    # Array of chars 0 - 9 + a - f
    HEX = B10 + ('a'..'f').to_a
  end

  ##
  # The base system and character set to use for number conversions.
  #
  # @!attribute [r] chars
  #   @return [Array<String>] The ASCII character set in use.
  # @!attribute [r] base
  #   @return [Fixnum] The base level in use.
  # @!attribute [r] values
  #   @return [Hash{String=>Fixnum}] A hash of characters and their respective
  #     value.
  #   @example Testing base hash default values.
  #     > test = Radix::Base.new(36)
  #     > test.values["F"]
  #     15 
  #     > test.values["5"]
  #     5
  #     > test.values["Y"]
  #     34
  #     > test.values["YY"] 
  #     nil       # Fails because "YY" is not a key in the +values+ hash.
  class Base

    attr :chars

    attr :base

    attr :values

    ##
    # New Radix using +chars+ representation.
    #
    # @param [String, Numeric] chars String to represent the number values of
    #   the base or a Numeric of the Base level.
    # @return [void]
    def initialize(chars=BASE::B62)
      if ::Numeric === chars
        chars = BASE::B62[0...chars]
      end
      @chars  = chars.map{ |c| c.to_s }
      @base   = @chars.size
      @values = Hash[*(0...@base).map { |i| [ @chars[i], i ] }.flatten]
    end

    ##
    # Convert a value of given radix_base to that of the base instance.
    #
    # @param [String, Numeric, Array<String>] number The value in "radix_base"
    #   context.
    # @param [Radix::Base, Numeric] radix_base Numeric for the radix or
    #   instance of Radix::Base.
    # @return [String] representation of "number" in self.base level.
    # @example Convert Testing (Binary, Decimal, Hex)
    #   > b = Radix::Base.new(2)
    #   > d = Radix::Base.new(10)
    #   > h = Radix::Base.new(16)
    #   > d.convert("A", h)
    #   "10"
    #   > h.convert("A", d)
    #   TypeError
    #   > h.convert(10, d)
    #   "A"
    #   > h.convert(10, 10)
    #   "A"
    #   > b.convert(10, d)
    #   "1010"
    #   > b.convert(10, h)
    #   "10000"
    def convert(number, radix_base)
      radix_base = Radix::Base.new(radix_base) unless Radix::Base === radix_base
      case number
      when ::String, ::Numeric
        digits = number.to_s.split(//)
      else
        digits = number
      end

      # decode the digits
      digits = digits.map{ |digit| radix_base.values[digit] }

      # THINK: Is best way to check for base out of bounds?
      raise TypeError if digits.any?{ |digit| digit.nil? }

      digits = Radix.convert_base(digits, radix_base.base, base)
      digits = digits.map{ |digit| chars[digit] }
      digits.join
    end

    ##
    # Convert any base to any other base, using array of Fixnum's. Indexes of
    # the array correspond to values for each column of the number in from_base
    #
    # @param [Array<Fixnum>] digits Array of values for each digit of source
    #   base.
    # @param [Fixnum] from_base Source Base
    # @param [Fixnum] to_base Destination Base
    # @return [String] The value of digits in from_base converted as to_base.
    def convert_base(digits, from_base, to_base)
      bignum = 0
      digits.each { |digit| bignum = bignum * from_base + digit }
      converted = []
      until bignum.zero?
        bignum, digit = bignum.divmod(to_base)
        converted.push(digit)
      end
      converted << 0 if converted.empty?  # THINK: correct?
      converted.reverse
    end

    ##
    # Encode a string in the radix.
    #
    # @param [String] byte_string String value in this base. 
    # @return [String] Encoded string from this Base.
    def encode(byte_string)
      digits = byte_string.unpack("C*")
      digits = Radix.convert_base(digits, 256, base)
      digits.map{ |d| @chars[d] }.join
    end

    ##
    # Decode a string that was previously encoded in the radix.
    #
    # @param [String] encoded Encoded string from this Base.
    # @return [String] Decoded string of value from this base. 
    def decode(encoded)
      digits = encoded.split(//).map{ |c| @values[c] }
      Radix.convert_base(digits, base, 256).pack("C*")
    end

  end

  ##
  # Convert a number of from_base as to_base.
  #
  # @param [String, Numeric, Array<String>] number The value in context of
  #   "radix_base".
  # @param [Fixnum, Radix::Base] from_base Source Base
  # @param [Fixnum, Radix::Base] to_base Destination Base
  # @return [String] The value of +digits+ in +from_base+ converted into
  #   +to_base+.
  def self.convert(number, from_base, to_base)
    from_base = Radix::Base.new(from_base) unless Radix::Base === from_base
    to_base   = Radix::Base.new(to_base)   unless Radix::Base === to_base
    to_base.convert(number, from_base)
  end

  ##
  # @see #convert_base
  def self.convert_base(digits, from_base, to_base)
    bignum = 0
    digits.each { |digit| bignum = bignum * from_base + digit }
    converted = []
    until bignum.zero?
      bignum, digit = bignum.divmod(to_base)
      converted.push(digit)
    end
    converted << 0 if converted.empty?  # THINK: correct?
    converted.reverse
  end

end

  ##
  # Radix::Base provides the means of converting to and from any base.
  #
  #   b10 = Radix::Base.new(10)
  #   b10.convert_base([100, 10], 256)
  #   #=> [2,5,6,1,0]
  #
  # And it can handle any notation upto base 62.
  #
  #   b10.convert("10", 62)  #=> "62"
  #
  # And the notations need not be in ASCII order --odd notations
  # can be used.
  #
  #   b10 = Radix::Base.new(%w{Q W E R T Y U I O U})
  #   b10.convert("FF", 16) #=> "EYY"ta
  #
  # NOTE: Radix::Base is the original Radix API. But with the advent of v2.0
  # and the new Integer and Float classes, it is outmoded. For now it is here
  # for backward compatibility. In a future version it may be deprecated, or
  # reworked to serve as the backbone of the other classes.
