# Synopsis

Radix provides the means of converting to and from any base.
For example, a number in base 256 can be represented by the array [100, 10]
(ie. 100**256 + 10**1) and easily converted to base 10.

    [100,10].b(256).to_i  #=> 25610

We can get an Array representation as well.

    [100,10].b(256).to_a(10)  #=> [2,5,6,1,0]
    [100,10].b(256).to_a(62)  #=> [6,41,4]
    [100,10].b(256).to_a(64)  #=> [6,16,10]

To get a String representation for any base use #to_s.

    [100,10].b(256).to_s(10)  #=> "25610"
    [100,10].b(256).to_s(62)  #=> "6 41 4"
    [100,10].b(256).to_s(64)  #=> "6 16 10"

Notice that anything above base 10 is seperated by a space divider. The divider
can be changed by providing a second argument.

    [100,10].b(256).to_s(64, ':')  #=> "6:16:10"

A string representation of a number can be converted upto base 62 (B62).

    "10".b(62).to_s(10)  #=> "62"
    "zz".b(62).to_s(10)  #=> "3843"

To encode a number with a base greater than 10, use an Array base. Radix
provides a built-in set of these, such as `BASE::B62`.

    [100,10].b(256).to_s(Radix::BASE::B62)  #=> "6f4"

To use a custom character set, use an array of characters as the base
rather than an integer. For example we can convert a base 10 number
to another base 10 number but useing a different encoding.

    base = %w[Q W E R T Y U I O U]

    "10".b(10).to_a(base)  #=> ["W", "Q"]

    "10".b(10).to_s(base)  #=> "WQ"

All of the above holds equally for floating point numbers.
