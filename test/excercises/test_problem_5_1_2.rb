require 'test_helper'

class TestProblem512 < Minitest::Test
  extend Minitest::Spec::DSL

  let(:sig) { {m: 0, f: 1, S: 2, B: 2} }

  def test_1
    assert "S(m, x)".to_formula.wellformed?(sig)
  end

  def test_2
    assert "B(m,f(m))".to_formula.wellformed?(sig)
  end

  def test_3
    assert "B(B(m,x),y)".to_formula.wellformed?(sig)
  end

  def test_4
    assert "B(x,y) ==> (exists z. S(z,y))".to_formula.wellformed?(sig)
  end

  def test_5
    assert "S(x,y) ==> S(y,f(f(x)))".to_formula.wellformed?(sig)
  end
end
