require 'hpsqrt/inspect_mode'
require 'hpsqrt/term'
require 'hpsqrt/version'


class HpSqrt < Numeric

  @@inspect_mode = INSPECT_MODE::VALUE

  def self.inspect_mode
    @@inspect_mode
  end

  def self.inspect_mode=(v)
    @@inspect_mode = v
  end


  attr_reader :terms

  def initialize(terms)
    @terms = terms.freeze
    @cache = {}
    freeze
  end
  private :initialize

  def -@
    terms = @terms.map{|t,c| [t, -c]}.to_h
    self.class.new(terms)
  end

  def +(other)
    other = self.class.create(other)

    terms = @terms.merge(other.terms) {|t, c1, c2|
      c1 + c2
    }
    terms.delete_if {|t,c| c==0}

    self.class.new(terms)
  end

  def -(other)
    other = self.class.create(other)

    other_terms = other.terms.map{|t,c| [t, -c]}.to_h
    terms = @terms.merge(other_terms) {|t, c1, c2|
      c1 + c2
    }
    terms.delete_if {|t,c| c==0}

    self.class.new(terms)
  end

  def *(other)
    other = self.class.create(other)

    terms = {}
    @terms.each {|t1, c1|
      other.terms.each {|t2, c2|
        t = t1 * t2
        c = c1 * c2

        terms[t] ||= 0
        terms[t] += c
      }
    }
    terms.delete_if {|t,c| c==0}

    self.class.new(terms)
  end

  def /(other)
    other = self.class.create(other)
    other_inv = Term.new(number: Rational(1, other.to_rc))

    terms = {}
    @terms.each {|t, c|
      t *= other_inv

      terms[t] ||= 0
      terms[t] += c
    }
    terms.delete_if {|t,c| c==0}

    self.class.new(terms)
  end

  def **(other)
    other = self.class.create(other)

    if other.integer?
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
      self.class.number(self.to_rc ** other.to_rc)
    end
  end

  def coerce(other)
    [self.class.create(other), self]
  end

  def ==(other)
    if self.class==other
      self.to_rc==other.to_rc
    elsif Numeric===other
      self.to_rc==other
    else
      super.==(other)
    end
  end

  def <=>(other)
    if !(Numeric===other)
      nil
    elsif self==other
      0
    elsif !self.imag.zero? || !other.imag.zero?
      nil
    else
      self.real <=> other.real
    end
  end

  def rect
    to_c.rect
  end

  def polar
    to_c.polar
  end

  def arg
    to_c.arg
  end
  alias_method :angle, :arg
  alias_method :phase, :arg

  def to_rc
    @cache[:to_rc] ||= @terms.map {|t, c|
      nc = Complex(t.number.real.to_r, t.number.imag.to_r)

      sc = Math.sqrt(Complex(t.sqrt))
      sc = Complex(sc.real.to_r, sc.imag.to_r)

      nc * sc * c
    }.sum(Complex(0.to_r, 0.to_r))
  end

  def to_c
    @cache[:to_c] ||= Complex(to_rc.real.to_f, to_rc.imag.to_f)
  end

  def real
    to_c.real
  end

  def imag
    to_c.imag
  end
  alias_method :imaginary, :imag

  def to_i
    if imag.zero?
      real.to_i
    else
      raise RangeError, "can't convert %s into Integer" % to_c
    end
  end

  def to_f
    if imag.zero?
      real.to_f
    else
      raise RangeError, "can't convert %s into Float" % to_c
    end
  end

  def to_r
    if to_rc.imag.zero?
      to_rc.real
    else
      raise RangeError, "can't convert %s into Rational" % to_rc
    end
  end

  def expr
    @cache[:expr] ||= begin
      value_to_s = -> (v) {
        if Complex===v && v.imag.zero?
          v = v.real
        end
        if Rational===v && v.denominator==1
          v = v.numerator
        end
        v = v.to_s
        if v !~ /^[\d\.]+$/
          v = "(%s)" % v
        end
        v
      }

      result = @terms.map {|t, c|
        n = t.number * c
        s = t.sqrt

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
    false
  end

  def complex?
    !to_rc.imag.zero?
  end

  def integer?
    to_rc.imag.zero? && to_rc.real.denominator==1
  end

  def float?
    to_rc.imag.zero? && to_rc.real.denominator!=1
  end

  def self.create(v)
    if self===v
      v
    else
      number(v)
    end
  end

  def self.number(v)
    if v!=0
      new({Term.new(number: v) => 1})
    else
      zero
    end
  end

  def self.sqrt(v)
    if self===v
      v = v.to_rc
    end
    if v!=0
      new({Term.new(sqrt: v) => 1})
    else
      zero
    end
  end

  def self.zero
    new({})
  end
end
