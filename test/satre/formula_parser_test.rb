require 'test_helper'

class FormulaParserTest < Minitest::Test
  def test_example_1
    "forall x y. exists z. x < z /\\ y < z".to_formula
k end

  def test_example_2
    "~(forall x. P(x)) <=> exists y. ~P(y)".to_formula
  end
end

