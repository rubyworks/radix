require 'radix'

feature "Integer Instantiation" do

  scenario "given an integer value and base" do
    to do |int, base|
      Radix::Integer.new(int, base)
    end

    valid do |result, compare|
      result.digits == compare
    end

    ok [ 8,  2] => [1,0,0,0]
    ok [ 4,  2] => [1,0,0]
    ok [ 8, 10] => [8]
    ok [10, 10] => [1, 0]
    ok [ 8, 16] => [8]
    ok [16, 16] => [1, 0]
  end

  # notice in the string case that the string is expected
  # to be in the given base already.
  scenario "given an string value and base" do
    to do |str, base|
      Radix::Integer.new(str, base)
    end

    valid do |result, compare|
      result.digits == compare
    end

    ok [ "1000",  2] => [1,0,0,0]
    ok [  "100",  2] => [1,0,0]
    ok [    "8", 10] => [8]
    ok [   "10", 10] => [1, 0]
    ok [    "8", 16] => [8]
    ok [   "10", 16] => [1, 0]
  end

end

