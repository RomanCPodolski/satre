require 'test_helper'

class NotTest < Minitest::Test
  extend Minitest::Spec::DSL

  let(:a) {Atom.new 'a'}
  let(:not_a) {Not.new a}

  def test_new
    assert_instance_of Not, not_a
    assert_kind_of Formula, not_a
  end

  def test_to_fomula
    assert_equal '~a'.to_formula, not_a
  end

  def test_to_s
    assert_equal '(¬a)', not_a.to_s
  end

  def test_literal
    assert_equal a, not_a.literal
  end

  def test_eval
    refute not_a.eval a: true
    assert not_a.eval a: false
  end
end
