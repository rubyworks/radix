# Ruby's String#b (Issue #10)

Since version 2.0, Ruby has had a `String#b` method of its own, which returns
a copy of the string in ASCII-8BIT encoding. Radix uses the same name, with a
base, to make a Radix number from a string.

    "10".b(62).to_i  #=> 62

Called without a base, it is still Ruby's method.

    string = "héllo"
    binary = string.b

    binary.encoding     #=> Encoding::ASCII_8BIT
    binary.bytes        #=> string.bytes
    binary.equal?(string).assert == false
    string.encoding     #=> Encoding::UTF_8

Ruby's method is also available as `String#ascii`.

    "héllo".ascii.encoding  #=> Encoding::ASCII_8BIT
