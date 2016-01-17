require 'test_helper'

class FormulaParserTest < Minitest::Test
  def test_example_1
    assert_equal "forall x y. exists z. x < z /\\ y < z".to_formula,
      Forall.new('x', Forall.new('y', Exists.new('z', And.new(Atom.new(Relation.new("<", [Variable.new('x'), Variable.new('z')])), Atom.new(Relation.new("<", [Variable.new('y'), Variable.new('z')]))))))
  end

  def test_example_2
    assert_equal "~(forall x. P(x)) <=> exists y. ~P(y)".to_formula,
      Iff.new(Not.new( Forall.new('x', Atom.new(Relation.new('P', [Variable.new('x')])))), Exists.new('y', Not.new(Atom.new(Relation.new('P',[Variable.new('y')])))))
  end
end
