require 'ae/should'

$LOAD_PATH.unshift(File.dirname(__FILE__) + '/../../lib')

require 'radix'

def check(&block)
  @_check = block
end

def ok(*args)
  @_check.call(*args)
end

