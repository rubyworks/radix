# Maximum single-charcter encoded base supported.
BASE62 = ["0".."9", "A".."Z", "a".."z"].map{ |r| r.to_a }.flatten

# Lamda for producing any subset of BASE62.
BASE = lambda{ |n| BASE62[0...n] }

#BASE10 = ["0".."9"].map { |r| r.to_a }.flatten
#BASE12 = ["0".."9", ["X", "E"]].map { |r| r.to_a }.flatten
#BASE16 = ["0".."9", "A".."F"].map { |r| r.to_a }.flatten
#BASE36 = ["0".."9", "A".."Z"].map { |r| r.to_a }.flatten
#BASE60 = ["0".."9", "a".."z", "A".."X"].map { |r| r.to_a }.flatten

class Integer

  #
  def digits(base=10)
    case base
    when Array
      table = base
      base  = base.size               
    else
      table = (0...base).to_a
    end

    raise ArgumentError unless base > 1

    i = abs
    a = []
    while i > 0
      i, r = i.divmod(base)
      a << table[r] #a << r
    end
    d = a.reverse
    d.unshift('-') if self < 0
    d
  end

end

class Float

  #--
  # TODO: Doe Float have another way to handle precision?
  #++
  def digits(base=10, prec=10)
    case base
    when Array
      table = base
      base  = base.size               
    else
      table = (0...base).to_a
    end

    raise ArgumentError unless base > 1

    value = to_f.abs

    i, f = value.split

    a = []
    while i > 0
      i, r = i.divmod(base)
      a << table[r] #a << r
    end

    p = prec
    b = []
    while !f.zero?
      k = (f * base)
      r, f = k.split
      break if p == 0; p -= 1
      b << table[r] #b << r
    end

    b << 0 if b.empty?

    d = a.reverse + ['.'] + b
    d.unshift('-') if self < 0
    d
  end

  #
  def split
    i, f = to_s.split('.')
    return i.to_i, ('0.'+f).to_f
  end

end

