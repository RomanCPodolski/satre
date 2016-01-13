require 'test_helper'

class TrueTest < Minitest::Test
  extend Minitest::Spec::DSL

  let(:t){True.new}

  def test_new
    assert_instance_of(True, t)
    assert_kind_of(Formula, t)
    assert_equal '⊤', t.base
  end

  def test_to_fomula
    assert_equal t, 'True'.to_formula
  end

  def test_eval
    assert t.eval
  end

  def test_atoms
    assert_equal t.atoms, []
  end

end
