require 'hpsqrt/inspect_mode'
require 'hpsqrt/value'
require 'hpsqrt/version'


class HpSqrt < Numeric

  @@inspect_mode = INSPECT_MODE::VALUE

  def self.inspect_mode
    @@inspect_mode
  end

  def self.inspect_mode=(v)
    @@inspect_mode = v
  end


  attr_reader :values

  def initialize(values)
    @values = values.freeze
    freeze
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
    other_inv = Value.new(number: Rational(1, other.to_c))

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
      self.class.number(self.to_c ** other.to_c)
    end
  end

  def coerce(other)
    [self.class.create(other), self]
  end

  def ==(other)
    if self.class==other
      self.to_c==other.to_c
    elsif Numeric===other
      self.to_c==other
    else
      super.==(other)
    end
  end

  def to_c
    @values.map {|v, c|
      v.number * Math.sqrt(Complex(v.sqrt)) * c
    }.sum.to_c
  end

  def real
    to_c.real
  end

  def imag
    to_c.imag
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

  def to_r
    to_c.to_r
  end

  def expr
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
      to_c.to_s
    when INSPECT_MODE::EXPR
      expr
    else
      "#<%s:0x%016x value=(%s) expr=(%s)>" % [self.class.name, self.object_id, to_c, expr]
    end
  end

  def real?
    imag.zero?
  end

  def imag?
    !real?
  end

  def int?
    v = to_c
    is_imag = Complex===v && !v.imag.zero?
    !is_imag && v.real==v.real.to_i
  end

  def float?
    v = to_c
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
    if self===v
      v = v.to_c
    end
    new({Value.new(sqrt: v) => 1})
  end
end
