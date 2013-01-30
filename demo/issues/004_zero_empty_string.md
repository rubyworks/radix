# Zero becomes empty string (#4)

Example of the issue:

    0.b(10).to_s  #=> ""

I would expect "0" as a result.

    0.b(10).to_s  #=> "0"

Okay, lets make sure this works for Floats.

    0.0.b(10).to_s  #=> "0.0"

And Rationals too.

    [0,1].br(10).to_s  #=> "0/1"

