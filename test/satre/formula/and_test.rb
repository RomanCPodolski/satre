require 'test_helper'

class AndTest < Minitest::Test
  extend Minitest::Spec::DSL

  let(:a) {Atom.new('a')}
  let(:b) {Atom.new('b')}
  let(:a_and_b) {And.new(a,b)}

  def test_new
    assert_instance_of(And, a_and_b)
    assert_kind_of(Formula, a_and_b)
    assert_equal(a, a_and_b.left_conjunct)
    assert_equal(b, a_and_b.right_conjunct)
    assert_equal('(a ∧ b)', a_and_b.base)
  end

  def test_to_fomula
    assert_equal('(a /\\ b)'.to_formula, a_and_b)
    assert_instance_of(And, '(a /\\ b)'.to_formula)
    assert_kind_of(Formula, '(a /\\ b)'.to_formula)
  end

  def test_eval
    assert(a_and_b.eval a: true,  b: true)
    refute(a_and_b.eval a: false, b: true)
    refute(a_and_b.eval a: true,  b: false)
    refute(a_and_b.eval a: false, b: false)
  end

  def test_atoms
    assert_equal(['a','b'], a_and_b.atoms)
  end

end
