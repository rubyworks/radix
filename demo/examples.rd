= Examples of Radix

First require the library.

  require 'radix'

First let's try something we all know, hexideciaml.
First we setup the radix for each.

  b10 = Radix.new(Radix::BASE10)
  b16 = Radix.new(Radix::BASE16)

Now we can covert from one to the other.

  b16.convert("16" , b10).should == "10"
  b16.convert("160", b10).should == "A0"
  b16.convert("255", b10).should == "FF"

To Confirm, we convert from deciaml to hexidecimal.

  b10.convert("10", b16).should == "16"
  b10.convert("A0", b16).should == "160"
  b10.convert("FF", b16).should == "255"

If we we want to use standard encodings then we
can simple provide an integer base, rather than
a Radix class.

  b10.convert("10", 16).should == "16"
  b10.convert("A0", 16).should == "160"
  b10.convert("FF", 16).should == "255"

We can also use the module function to convert
to and from standard notations upto 62 without
creating an instance of Radix.

  Radix.convert("10", 16, 10).should == "16"
  Radix.convert("A0", 16, 10).should == "160"
  Radix.convert("FF", 16, 10).should == "255"

Let's try that again with the mazimum base supported.

  Radix.convert(     "62", 10, 62).should == "10"
  Radix.convert("8814542", 10, 62).should == "AZ42"

  Radix.convert(     "10", 62, 10).should == "62"
  Radix.convert(   "AZ42", 62, 10).should == "8814542"

Radix can also be used to encode and decode strings.

  b16.encode("CHARLIE").should == "434841524C4945"
  b16.decode("434841524C4945").should == "CHARLIE"

Now let's try a more down to earth base, my favorite,
senary, or base six.

  b6  = Radix.new(0..5)
  b6.convert("39", 10).should == "103"

And the notations need not be in ASCII order. Odd alternate notations
can be used as well.

  b10 = Radix.new([:Q, :W, :E, :R, :T, :Y, :U, :I, :O, :U])
  b10.convert("FF", 16) #=> "EYY"

Finally, we will demonstrate how to convert bases larger than 62.
These can only be represented as arrays since there are not enough
latin characters to represent them.

  Radix.convert_base([100, 10], 256, 10).should == [2, 5, 6, 1, 0]
  Radix.convert_base([2, 5, 6, 1, 0], 10, 256).should == [100, 10]

QED.