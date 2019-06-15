require 'hpsqrt'


module Kernel

  Sqrt = HpSqrt

  def Sqrt(v)
    Sqrt.sqrt(v)
  end
end
