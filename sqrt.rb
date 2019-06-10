class Sqrt < Numeric

  module INSPECT_MODE
    EXPR = :expr
    VALUE = :value
  end

  @@inspect_mode = INSPECT_MODE::VALUE


  attr_reader :values

  def initialize(values)
    @values = values
  end

  def -@
    values = self.values.map{|k,v| [k, -v]}.to_h
    self.class.new(values)
  end

  def +(other)
    other = self.class.create(other)

    values = @values.merge(other.values) {|k, v1, v2|
      v1 + v2
    }
    values.delete_if {|k,v| v==0}

    self.class.new(values)
  end

  def -(other)
    other = self.class.create(other)

    other_values = other.values.map{|k,v| [k, -v]}.to_h
    values = @values.merge(other_values) {|k, v1, v2|
      v1 + v2
    }
    values.delete_if {|k,v| v==0}

    self.class.new(values)
  end

  def *(other)
    other = self.class.create(other)

    values = {}
    @values.each {|k1, v1|
      other.values.each {|k2, v2|
        k = k1 * k2
        v = v1 * v2

        sign = 1
        #if Complex===k1 && Complex===k2 && k1.imag==k2.imag && (k1.real<0 || k2.real<0) && 0<=k.real
        if Complex===k1 && Complex===k2 && k1.imag==k2.imag && (k1.real<0 || k2.real<0)
          sign = -1
        end

        values[k] ||= 0
        values[k] += v * sign
      }
    }
    values.delete_if {|k,v| v==0}

    self.class.new(values)
  end

  def /(other)
    # TODO
    other = self.class.create(other)
    self.class.number(self.value / other.value)
  end

  def **(other)
    other = self.class.create(other)

    if other.int?
      result = self.class.create(1)
      other_i = other.to_i
      other_i.abs.times {|i|
        result *= self
      }
      if other_i<0
        result = Rational(1, result)
      end
      result
    else
      #if @values.length==1 && other.values.length==1
      #  k2 = other.value
      #  #if k2.to_i==k2
      #  #  k2 = k2.to_i
      #  #end
      #  v2 = k2<0 ? -1 : 1
      #  k2 *= v2

      #  values = {}
      #  @values.each {|k1, v1|
      #    if v2==1
      #      k = k1 ** k2
      #    else
      #      k = Rational(1, k1 ** k2)
      #    end

      #    values[k] ||= 0
      #    values[k] += v1
      #  }
      #  values.delete_if {|k,v| v==0}

      #  self.class.new(values)
      #else
        self.class.number(self.value ** other.value)
      #end
    end
  end

  def coerce(other)
    [self.class.create(other), self]
  end

  def ==(other)
    if self.class==other
      self.value==other.value
    elsif Numeric===other
      self.value==other
    else
      super.==(other)
    end
  end

  def value
    @values.map {|k, v|
      Math.sqrt(k) * v
    }.sum
  end

  def to_i
    value.to_i
  end

  def to_f
    value.to_f
  end

  def to_c
    value.to_c
  end

  def to_r
    value.to_r
  end

  def to_expr_s
    result = @values.map {|k, v|
      k_str = k.to_s
      if Complex===k || Rational===k
        k_str = "(%s)" % k_str
      end

      if v==1
        "\u221A%s" % [k_str]
      elsif 0<v
        "%s\u221A%s" % [v, k_str]
      elsif v==-1
        "(-\u221A%s)" % [k_str]
      else
        "(%s\u221A%s)" % [v, k_str]
      end
    }

    if 0<result.length
      result.join(" + ")
    else
      "0"
    end
  end

  def inspect
    case @@inspect_mode
    when INSPECT_MODE::EXPR
      to_expr_s
    when INSPECT_MODE::VALUE
      value.to_s
    end
  end

  def to_s
    inspect
  end

  def real?
    !imag?
  end

  def imag?
    v = value
    Complex===v && !v.imag.zero?
  end

  def int?
    v = value
    is_imag = Complex===v && !v.imag.zero?
    !is_imag && v.real==v.real.to_i
  end

  def float?
    v = value
    is_imag = Complex===v && !v.imag.zero?
    !is_imag && v.real!=v.real.to_i
  end

  def self.create(v)
    if self===v
      v
    else
      number(v)
    end
  end

  def self.number(v)
    sign = Complex(v).real<0 ? -1 : 1
    new({(v ** 2) => sign})
  end

  def self.sqrt(v)
    if Complex(v).real<0
      new({v*-1 => -1})
    else
      new({v => 1})
    end
  end
end


module Kernel
  def Sqrt(v)
    Sqrt.sqrt(v)
  end
end
