require 'test_helper'

class TestProblem52 < Minitest::Test
  extend Minitest::Spec::DSL

  let(:domain) { (0..23) }

  def test_parse_first_axiom
    skip
    assert "forall x. x approx x".to_formula
  end
  
  def test_parse_second_axiom
    skip
    assert "forall x y. (x approx y ==> y approx x)".to_formula
  end

  def test_parse_thrird_axiom
    skip
    assert "forall x y z. (x approx y /\\ y approx x ==> x approx z)".to_formula
  end

  def test_2
    skip
  end

  def test_3
    skip
  end
end
