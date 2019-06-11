require 'hpsqrt'


module Kernel
  def Sqrt(v)
    HpSqrt.sqrt(v)
  end
end
