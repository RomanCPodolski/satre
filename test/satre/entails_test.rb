require 'test_helper'

class EntailsTest < Minitest::Test
  extend Minitest::Spec::DSL

  let(:a) {Atom.new 'a'}
  let(:b) {Atom.new 'b'}
  let(:a_entails_b) {Entails.new(a, b)}

  def test_new
    assert_instance_of(Entails, a_entails_b)
    assert_kind_of(Formula, a_entails_b)
    assert_equal a, a_entails_b.p
    assert_equal b, a_entails_b.q
    assert_equal "(a ⊨ b)", a_entails_b.base
  end

  def test_to_fomula
    assert_equal "a |= b".to_formula, a_entails_b
  end

  def test_eval
    skip 'to do later - to much thinkin now'
  end

  def test_atoms
    assert_equal(['a', 'b'], a_entails_b.atoms)
  end

end
