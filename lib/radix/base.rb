# Radix coverts to and from any base.
#
# Base conversions with ASCII ordered notations are easy in Ruby.
#
#   255.to_s(16)   #=> "FF"
#   "FF".to_i(16)  #=> 255
#
# But Ruby reaches it's limit at base 36.
#
#   255.to_s(37)   #=> Error
#
# Radix provides the means of converting to and from any base.
#
#   Radix::Base.convert_base([100, 10], 256, 10)
#   #=> [2,5,6,1,0]
#
# And it can handle any notation upto base 62.
#
#   Radix::Base.convert("10", 62, 10)  #=> "62"
#
# And the notations need not be in ASCII order --odd notations
# can be used.
#
#   b10 = Radix::Base.new([:Q, :W, :E, :R, :T, :Y, :U, :I, :O, :U])
#   b10.convert("FF", 16) #=> "EYY"
#
module Radix

  class Base

    BASE10 = ["0".."9"].map { |r| r.to_a }.flatten
    BASE12 = ["0".."9", ["X", "E"]].map { |r| r.to_a }.flatten
    BASE16 = ["0".."9", "A".."F"].map { |r| r.to_a }.flatten
    BASE36 = ["0".."9", "A".."Z"].map { |r| r.to_a }.flatten
    BASE60 = ["0".."9", "a".."z", "A".."X"].map { |r| r.to_a }.flatten
    BASE62 = ["0".."9", "a".."z", "A".."Z"].map { |r| r.to_a }.flatten

    attr :chars
    attr :base
    attr :values

    # New Radix using +chars+ representation.
    def initialize(chars=BASE62)
      @chars  = chars.map{ |c| c.to_s }
      @base   = @chars.size
      @values = Hash[*(0...@base).map { |i| [ @chars[i], i ] }.flatten]
    end

    # Encode a string in the radix.
    def encode(byte_string)
      digits = byte_string.unpack("C*")
      digits = convert_base(digits, 256, base)
      digits.map{ |d| @chars[d] }.join
    end

    # Decode a string that was previously encoded in the radix.
    def decode(encoded)
      digits = encoded.split(//).map{ |c| @values[c] }
      convert_base(digits, base, 256).pack("C*")
    end

    # Convert a representational +number+ of +from_radix+ to the radix.
    def convert(number, from_radix)
      from_radix = standard_radix(from_radix) if Integer === from_radix
      digits = number.to_s.split(//)
      digits = digits.map{ |digit| from_radix.values[digit] }
      digits = convert_base(digits, from_radix.base, base)
      digits = digits.map{ |digit| chars[digit] }
      digits.join
    end

    # Convert any base to any other base, using array of +digits+.
    def convert_base(digits, from_base, to_base)
      self.class.convert_base(digits, from_base, to_base)
    end

    private

    def standard_radix(integer_base)
      self.class.standard_radix(integer_base)
    end

    public

    # Do a standard conversion upto base 62.
    def self.convert(number, from_base, to_base)
      r1 = standard_radix(from_base)
      r2 = standard_radix(to_base)
      r2.convert(number, r1)
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
      converted.reverse
    end

    # Provide a standard representation of a base upto 62.
    def self.standard_radix(integer_base)
      if integer_base > 36
        new(BASE62[0..integer_base-1])
      else
        new(BASE36[0..integer_base-1])
      end
    end

  end

  # Do a standard conversion upto base 62.
  def self.convert(number, from_base, to_base)
    Radix::Base.convert(number, from_base, to_base)
  end

  # Convert any base to any other base, using array of +digits+.
  def self.convert_base(digits, from_base, to_base)
    Radix::Base.convert_base(digits, from_base, to_base)
  end

  # Provide a standard representation of a base upto 62.
  def self.standard_radix(integer_base)
    Radix::Base.standard_radix(integer_base)
  end

end

