# Radix::Base

The Radix::Base class is an encapsulatin of a numeric base. By creating
an instance of Base one can convert numbers to and from other bases.

    require 'radix/base'

## Base Instance

First let's try something we all know, converting decimal to hexideciaml.
To do this we setup the radix base objects for each base.

    b10 = Radix::Base.new(Radix::BASE::B10)
    b16 = Radix::Base.new(Radix::BASE::B16)

Now we can covert from one base to the other.

    b16.convert("16" , b10).should == "10"
    b16.convert("160", b10).should == "A0"
    b16.convert("255", b10).should == "FF"

To confirm, lets convert from hexidecimal back to decimal.

    b10.convert("10", b16).should == "16"
    b10.convert("A0", b16).should == "160"
    b10.convert("FF", b16).should == "255"

If we are happy with standard encodings then we can simply provide an
integer base, rather than a Radix::Base object.

    b10.convert("10", 16).should == "16"
    b10.convert("A0", 16).should == "160"
    b10.convert("FF", 16).should == "255"

Now let's try a more down to earth base, my favorite,
senary, or base six.

    b6  = Radix::Base.new(0..5)
    b6.convert("39", 10).should == "103"

And the notations need not be in ASCII order. Odd alternate notations
can be used as well.

    b10 = Radix::Base.new([:Q, :W, :E, :R, :T, :Y, :U, :I, :O, :U])
    b10.convert("FF", 16) #=> "EYY"

## Encoding and Decoding

Radix::Base instances can also be used to encode and decode strings.

    b16.encode("CHARLIE").should == "434841524C4945"
    b16.decode("434841524C4945").should == "CHARLIE"

## Module Methods

For further convenience, Radix::base provides functions to convert to and from
standard notations upto 62 without creating an instance of Radix::Base.

    Radix.convert("10", 16, 10).should == "16"
    Radix.convert("A0", 16, 10).should == "160"
    Radix.convert("FF", 16, 10).should == "255"

Let's try that again with the maximum base supported.

    Radix.convert(     "62", 10, 62).should == "10"
    Radix.convert("8814542", 10, 62).should == "az42"

    Radix.convert(     "10", 62, 10).should == "62"
    Radix.convert(   "az42", 62, 10).should == "8814542"

Finally, we will demonstrate how to convert bases larger than 62.
These can only be represented as arrays since there are not enough
latin characters to represent them.

    Radix.convert_base([100, 10], 256, 10).should == [2, 5, 6, 1, 0]
    Radix.convert_base([2, 5, 6, 1, 0], 10, 256).should == [100, 10]
    Radix.convert_base([1, 0, 1, 0, 1], 2, 10).should == [2, 1]

