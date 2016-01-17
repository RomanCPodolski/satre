require 'test_helper'

class AtomTest < Minitest::Test
  extend Minitest::Spec::DSL

  let(:a){Atom.new('a')}
  let(:b){Atom.new('b')}
  let(:c){Atom.new('c')}

  def test_new
    assert_instance_of Atom, a
    assert_kind_of Formula, a
  end

  def test_to_s
    assert_equal('a', a.to_s)
  end


  def test_ufo_operator
    assert_equal(-1, a <=> b)
    assert_equal( 0, b <=> b)
    assert_equal( 1, c <=> b)
  end

  def test_eval
    assert(a.eval(a: true))
    refute(a.eval(a: false))
  end

  def test_atoms
    assert_equal(a.atoms, [:a])
  end

end
