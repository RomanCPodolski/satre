require 'test_helper'

class FormulaParserTest < Minitest::Test
  def test_example_1
    assert_equal "forall x y. exists z. x < z /\\ y < z".to_fol, ''
k end

  def test_example_2
    assert_equal "~(forall x. P(x)) <=> exists y. ~P(y)".to_fol, ''
  end
end
