module Radix

  # Collection of base encodings.
  module BASE
    B10 = ('0'..'9').to_a
    B12 = B10 + ['X', 'E']
    B16 = B10 + ('A'..'F').to_a
    B36 = B10 + ('A'..'Z').to_a
    B60 = B36 + ('a'..'x').to_a
    B62 = B36 + ('a'..'z').to_a

    # Like BASE16 but encodes with lowercase letters.
    HEX = B10 + ('a'..'f').to_a
  end

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
  #   b10.convert("FF", 16) #=> "EYY"
  #
  # NOTE: Radix::Base is the original Radix API. But with the advent of v2.0
  # and the new Integer and Float classes, it is outmoded. For now it is here
  # for backward compatibility. In a future version it may be deprecated, or
  # reworked to serve as the backbone of the other classes.
  #
  class Base

    attr :chars

    attr :base

    attr :values

    # New Radix using +chars+ representation.
    def initialize(chars=BASE::B62)
      if Integer === chars
        chars = BASE::B62[0...chars]
      end
      @chars  = chars.map{ |c| c.to_s }
      @base   = @chars.size
      @values = Hash[*(0...@base).map { |i| [ @chars[i], i ] }.flatten]
    end

    # Convert an *encoded* +number+ of given +base+ to the Base's radix.
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

    # Convert any base to any other base, using array of +digits+.
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

    # Encode a string in the radix.
    def encode(byte_string)
      digits = byte_string.unpack("C*")
      digits = Radix.convert_base(digits, 256, base)
      digits.map{ |d| @chars[d] }.join
    end

    # Decode a string that was previously encoded in the radix.
    def decode(encoded)
      digits = encoded.split(//).map{ |c| @values[c] }
      Radix.convert_base(digits, base, 256).pack("C*")
    end

  end

  # Convert number from it's given base to antoher base.
  # Do a standard conversion upto base 62.
  def self.convert(number, from_base, to_base)
    from_base = Radix::Base.new(from_base) unless Radix::Base === from_base
    to_base   = Radix::Base.new(to_base)   unless Radix::Base === to_base
    to_base.convert(number, from_base)
  end

  # Convert any base to any other base, using array of +digits+.
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

