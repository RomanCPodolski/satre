require 'test_helper'

class FalseTest < Minitest::Test
  extend Minitest::Spec::DSL

  let(:f) {False.new}

  def test_new
    assert_instance_of(False, f)
    assert_kind_of(Formula, f)
  end

  def test_to_fomula
    assert_equal f, 'false'.to_formula
  end

  def to_s
    assert_equal '⊥', f.to_s
  end

  def test_eval
    refute f.eval
  end

  def test_atoms
    assert_equal [], f.atoms
  end
end
