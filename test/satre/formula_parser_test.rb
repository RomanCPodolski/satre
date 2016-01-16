require 'test_helper'

class FormulaParserTest < Minitest::Test
  def test_atom
    skip
    assert_equal 'x'.to_fol, ''
  end

  def test_imp
    skip
    assert_equal "x ==> y".to_fol, ''
  end

  def test_iff
    skip
    assert_equal "x <=> y".to_fol, ''
  end

  def test_or
    skip
    assert_equal "x \\/ y".to_fol, ''
  end

  def test_and
    skip
    assert_equal "x /\\ y".to_fol, ''
  end

  def test_forall
    skip
    assert_equal "forall x. y".to_fol, ''
  end
  
  def test_exists
    skip
    assert_equal "exists x. y".to_fol, ''
  end

  def test_operators
    skip
    assert_equal "x < y".to_fol, ''
  end

  def test_example_1
    skip
    assert_equal "forall x y. exists z. x < z /\\ y < z".to_fol, ''
  end

  def test_example_2
    assert_equal "~(forall x. P(x)) <=> exists y. ~P(y)".to_fol, ''
  end
end
