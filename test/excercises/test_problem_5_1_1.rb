require 'test_helper'

class TestProblem511 < Minitest::Test
  extend Minitest::Spec::DSL

  let(:sig) { {d: 0, f: 2, g: 3} }

  def test_1
    refute "g(d, d)".to_term.wellformed?(sig)
  end

  def test_2
    refute "f(x,g(y,z),d)".to_term.wellformed?(sig)
  end

  def test_3
    assert "g(x,f(y,z),d)".to_term.wellformed?(sig)
  end

  def test_4
    refute "g(x,h(y,z),d)".to_term.wellformed?(sig)
  end
end
