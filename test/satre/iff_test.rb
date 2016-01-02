require 'test_helper'

class IffTest < Minitest::Test
  extend Minitest::Spec::DSL

  let(:a) {Atom.new 'a'}
  let(:b) {Atom.new 'b'}
  let(:a_iff_b) {Iff.new(a,b)}

  def test_new
    assert_instance_of Iff, a_iff_b
    assert_kind_of Formula, a_iff_b
    assert_equal a, a_iff_b.p
    assert_equal b, a_iff_b.q
    assert_equal '(a → b)', a_iff_b.base
  end

  def test_to_fomula
    assert_equal a_iff_b, '(a => b)'.to_formula 
  end

  def test_eval
    assert a_iff_b.eval a: true,  b:true
    refute a_iff_b.eval a: false, b:true
    refute a_iff_b.eval a: true,  b:false
    assert a_iff_b.eval a: false, b:false
  end

  def test_atoms
    assert_equal ['a', 'b'], a_iff_b.atoms
  end
end
