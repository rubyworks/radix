# Encoding/decoding with custom character sets (#12)

There is not problem converting a numeric value into a custom base.

    c62 = (0..9).map{ |x| x.to_s } + ('a'..'z').to_a + ('A'..'Z').to_a

    809145531659995.b(c62).to_s  #=> "3HLszsQsP"

But there was a problem with decoding custom number back.

    "3HLszsQsP".b(c62).to_i   #=> 809145531659995


