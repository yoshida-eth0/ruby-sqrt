class Sqrt < Numeric

  module INSPECT_MODE
    VALUE = :value
    EXPR = :expr
    DUMP = :dump
  end

  @@inspect_mode = INSPECT_MODE::DUMP


  class Value
    attr_reader :number
    attr_reader :sqrt

    def initialize(number: 1, sqrt: 1)
      @number = number
      @sqrt = sqrt
    end

    def *(other)
      if self.class===other
        n = @number * other.number
        s = 1
        if @sqrt==other.sqrt
          n *= @sqrt
        else
          s = @sqrt * other.sqrt
        end

        self.class.new(number: n, sqrt: s)
      end
    end

    def eql?(other)
      self.class===other && @number==other.number && @sqrt==other.sqrt
    end

    def hash
      [@number, @sqrt].hash
    end
  end


  attr_reader :values

  def initialize(values)
    @values = values
  end

  def -@
    values = self.values.map{|v,c| [v, -c]}.to_h
    self.class.new(values)
  end

  def +(other)
    other = self.class.create(other)

    values = @values.merge(other.values) {|v, c1, c2|
      c1 + c2
    }
    values.delete_if {|v,c| c==0}

    self.class.new(values)
  end

  def -(other)
    other = self.class.create(other)

    other_values = other.values.map{|v,c| [v, -c]}.to_h
    values = @values.merge(other_values) {|v, c1, c2|
      c1 + c2
    }
    values.delete_if {|v,c| v==0}

    self.class.new(values)
  end

  def *(other)
    other = self.class.create(other)

    values = {}
    @values.each {|v1, c1|
      other.values.each {|v2, c2|
        v = v1 * v2
        c = c1 * c2

        values[v] ||= 0
        values[v] += c
      }
    }
    values.delete_if {|v,c| c==0}

    self.class.new(values)
  end

  def /(other)
    other = self.class.create(other)
    other_inv = Value.new(number: Rational(1, other.value))

    values = {}
    @values.each {|v, c|
      v *= other_inv

      values[v] ||= 0
      values[v] += c
    }
    values.delete_if {|v,c| c==0}

    self.class.new(values)
  end

  def **(other)
    other = self.class.create(other)

    if other.int?
      result = self.class.create(1)
      other_i = other.real.to_i
      other_i.abs.times {|i|
        result *= self
      }
      if other_i<0
        result = Rational(1, result)
      end
      result
    else
      self.class.number(self.value ** other.value)
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
    @values.map {|v, c|
      v.number * Math.sqrt(Complex(v.sqrt)) * c
    }.sum
  end

  def real
    value.real
  end

  def imag
    Complex(value).imag
  end

  def to_i
    c = to_c
    if c.imag.zero?
      c.real.to_i
    else
      raise RangeError, "can't convert %s into Integer" % c
    end
  end

  def to_f
    c = to_c
    if c.imag.zero?
      c.real.to_f
    else
      raise RangeError, "can't convert %s into Float" % c
    end
  end

  def to_c
    value.to_c
  end

  def to_r
    value.to_r
  end

  def to_expr_s
    value_to_s = -> (v) {
      if Complex===v && v.imag.zero?
        v = v.real
      elsif Rational===v
        v = v.to_s.sub(/\/1$/, "")
      end
      v = v.to_s
      if v !~ /^[\d\.]+$/
        v = "(%s)" % v
      end
      v
    }

    result = @values.map {|v, c|
      n = v.number * c
      s = v.sqrt

      if s!=1
        if n==1
          "\u221A%s" % value_to_s[s]
        elsif 0<n.real
          "%s\u221A%s" % [value_to_s[n], value_to_s[s]]
        elsif n==-1
          "(-\u221A%s)" % value_to_s[s]
        else
          "(%s\u221A%s)" % [value_to_s[n], value_to_s[s]]
        end
      else
        value_to_s[n]
      end
    }

    if 0<result.length
      result.join(" + ")
    else
      "0"
    end
  end

  def inspect
    to_s
  end

  def to_s
    case @@inspect_mode
    when INSPECT_MODE::VALUE
      value.to_s
    when INSPECT_MODE::EXPR
      to_expr_s
    when INSPECT_MODE::DUMP
      "#<%s:0x%016x value=(%s) expr=(%s)>" % [self.class.name, self.object_id, value, to_expr_s]
    end
  end

  def real?
    imag.zero?
  end

  def imag?
    !real?
  end

  def int?
    v = value
    is_imag = Complex===v && !v.imag.zero?
    !is_imag && v.real==v.real.to_i
  end

  def float?
    v = value
    is_imag = Complex===v && !v.imag.zero?
    !is_imag && Float===v.real && v.real!=v.real.to_i
  end

  def self.create(v)
    if self===v
      v
    else
      number(v)
    end
  end

  def self.number(v)
    new({Value.new(number: v) => 1})
  end

  def self.sqrt(v)
    new({Value.new(sqrt: v) => 1})
  end
end


module Kernel
  def Sqrt(v)
    Sqrt.sqrt(v)
  end
end
