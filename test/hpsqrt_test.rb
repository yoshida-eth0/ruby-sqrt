#$LOAD_PATH << File.expand_path(__FILE__+"/../../lib")

require 'test_helper'
require 'hpsqrt/core_ext'


class HpSqrtTest < Minitest::Test
  def test_simple
    # \sqrt{1}
    assert_equal 1, Sqrt(1)

    # \sqrt{2}
    assert_in_delta 1.4142135623730951, Sqrt(2).to_c

    # 1
    assert_equal 1, Sqrt.number(1)

    # 2
    assert_equal 2, Sqrt.number(2)
  end

  def test_operation
    # +\sqrt{1}
    assert_equal 1, +Sqrt(1)

    # -\sqrt{1}
    assert_equal (-1), -Sqrt(1)

    # \sqrt{2} + \sqrt{2}
    assert_in_delta 2.8284271247461903, (Sqrt(2) + Sqrt(2)).to_c

    # \sqrt{2} - \sqrt{2}
    assert_equal 0, Sqrt(2) - Sqrt(2)

    # \sqrt{2} * \sqrt{2}
    assert_equal 2, Sqrt(2) * Sqrt(2)

    # \sqrt{2} / \sqrt{2}
    assert_equal 1, Sqrt(2) / Sqrt(2)

    # \sqrt{2} ** 2
    assert_equal 2, Sqrt(2) ** 2

    # \sqrt{2} ** -2
    assert_equal 0.5, Sqrt(2) ** -2

    # \sqrt{2} ** -(\sqrt{2} ** 2)
    assert_equal 0.5, (Sqrt(2) ** -(Sqrt(2) ** 2)).to_c

    # \sqrt{2} ** \sqrt{2}
    assert_in_delta 1.632526919438153, (Sqrt(2) ** Sqrt(2)).to_c
  end

  def test_complex
    # MEMO: 虚数を含むComplexの.==(other)は、otherがNumericでありComplexではない場合falseになる
    #       なので、Sqrt.to_cでComplex同士を比較する

    # 1i
    assert_equal 1i, Sqrt.number(1i).to_c

    # 1i * 1i
    assert_equal (-1), Sqrt.number(1i) * Sqrt.number(1i)

    # \sqrt{1i}
    assert_equal Math.sqrt(1i), Sqrt(1i).to_c

    # \sqrt{1i} * \sqrt{1i}
    assert_equal 1i, (Sqrt(1i) * Sqrt(1i)).to_c

    # \sqrt{1i} * \sqrt{1i} * \sqrt{1i} * \sqrt{1i}
    assert_equal (-1), Sqrt(1i) * Sqrt(1i) * Sqrt(1i) * Sqrt(1i)
  end

  def test_exponentiation
    # \sqrt(3) * \sqrt{5} * \sqrt{15}
    assert_equal 15, Sqrt(3) * Sqrt(5) * Sqrt(15)

    # \sqrt{5} * \sqrt{7} * \sqrt{5} * \sqrt{7}
    assert_equal 35, Sqrt(5) * Sqrt(7) * Sqrt(5) * Sqrt(7)
  end

  def test_expansion
    # (\sqrt{7} + \sqrt{11}) * (\sqrt{7} - \sqrt{11})
    assert_equal (-4), (Sqrt(7) + Sqrt(11)) * (Sqrt(7) - Sqrt(11))

    # (\sqrt{7} + \sqrt{11}) * (\sqrt{7} + \sqrt{11})
    assert_in_delta 35.54992877478425, ((Sqrt(7) + Sqrt(11)) * (Sqrt(7) + Sqrt(11))).to_f

    # (\sqrt{7} + \sqrt{11}) ** 2
    assert_in_delta 35.54992877478425, ((Sqrt(7) + Sqrt(11)) ** 2).to_f

    # (\sqrt{7} + \sqrt{11}) / (\sqrt{7} + \sqrt{11})
    assert_equal 1, (Sqrt(7) + Sqrt(11)) / (Sqrt(7) + Sqrt(11))

    # (\sqrt{7} + \sqrt{11}) / (\sqrt{7} - \sqrt{11})
    assert_in_delta (-8.887482193696064), ((Sqrt(7) + Sqrt(11)) / (Sqrt(7) - Sqrt(11))).to_f
  end

  def test_nested_sqrt
    # \sqrt{\sqrt{16}}
    assert_equal 2, Sqrt(Sqrt(16))
  end

  def test_expr
    assert_equal "\u221A2", Sqrt(2).expr
    assert_equal "\u221A2 + \u221A3", (Sqrt(2) + Sqrt(3)).expr
    assert_equal "2\u221A2", (Sqrt(2) * 2).expr

    assert_equal "0", Sqrt(0).expr
    assert_equal "1", Sqrt(1).expr
    assert_equal "2", (Sqrt(2) ** 2).expr
  end
end
