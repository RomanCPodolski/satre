require 'test_helper'

class TestProblem512 < Minitest::Test
  extend Minitest::Spec::DSL

  let(:sig) { Signature.new {} }

  def test_1
    skip
    assert "S(m, x)".to_formula.wellformed?(sig)
  end

  def test_2
    skip
    assert "B(m,f(m))".to_formula.wellformed?(sig)
  end

  def test_3
    skip
    assert "B(B(m,x),y)".to_formula.wellformed?(sig)
  end

  def test_4
    skip
    assert "B(x,y) ==> (exists z. S(z,y))".to_formula.wellformed?(sig)
  end

  def test_5
    skip
    assert "S(x,y) ==> S(y,f(f(x)))".to_formula.wellformed?(sig)
  end
end
