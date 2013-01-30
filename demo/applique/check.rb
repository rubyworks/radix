def check(&block)
  @check = block
end

def ok(*args)
  @check.call(*args)
end
