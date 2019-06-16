class HpSqrt < Numeric

  class Term
    attr_reader :number
    attr_reader :sqrt

    def initialize(number: 1, sqrt: 1)
      unless Numeric===number
        raise TypeError, "can't convert %s into %s: %s" % [number.class.name, self.class.name, number.inspect]
      end
      unless Numeric===sqrt
        raise TypeError, "can't convert %s into %s: %s" % [sqrt.class.name, self.class.name, sqrt.inspect]
      end

      @number = number
      @sqrt = sqrt
      freeze
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

end
