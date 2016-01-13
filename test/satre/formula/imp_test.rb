require 'test_helper'

class ImpTest < Minitest::Test
  extend Minitest::Spec::DSL

  let(:a) {Atom.new 'a'}
  let(:b) {Atom.new 'b'}
  let(:a_imp_b) {Imp.new a, b}

  def test_new
    assert_instance_of Imp, a_imp_b
    assert_kind_of Formula, a_imp_b
    assert_equal a, a_imp_b.antendence
    assert_equal b, a_imp_b.consequence
    assert_equal '(a → b)', a_imp_b.base
  end

  def test_to_fomula
    assert_equal a_imp_b, '(a => b)'.to_formula 
  end

  def test_eval
    assert a_imp_b.eval a: true,  b:true
    refute a_imp_b.eval a: true,  b:false
    assert a_imp_b.eval a: false, b:true
    assert a_imp_b.eval a: false, b:false
  end

  def test_atoms
    assert_equal ['a', 'b'], a_imp_b.atoms
  end
end
