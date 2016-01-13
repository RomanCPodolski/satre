require 'test_helper'

class OrTest < Minitest::Test
  extend Minitest::Spec::DSL

  let(:a) {Atom.new 'a'}
  let(:b) {Atom.new 'b'}
  let(:a_or_b) {Or.new a, b}

  def test_new
    assert_instance_of Or, a_or_b
    assert_kind_of Formula, a_or_b
    assert_equal a, a_or_b.left_disjunct
    assert_equal b, a_or_b.right_disjunct
    assert_equal '(a ∨ b)', a_or_b.base
  end

  def test_to_fomula
    assert_equal(a_or_b, '(a \\/ b)'.to_formula)
    assert_instance_of(Or, '(a \\/ b)'.to_formula)
    assert_kind_of(Formula, '(a \\/ b)'.to_formula)
  end

  def test_eval
    assert a_or_b.eval a: true,  b: true
    assert a_or_b.eval a: false, b: true
    assert a_or_b.eval a: true,  b: false
    refute a_or_b.eval a: false, b: false
  end

  def test_atoms
    assert_equal ['a', 'b'], a_or_b.atoms
  end

end
