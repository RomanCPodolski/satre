require 'test_helper'

class TestProblem52 < Minitest::Test
  extend Minitest::Spec::DSL

  let(:domain) { (0..23).to_a }
  let(:axiom_1) { "forall x. x = x".to_formula }
  let(:axiom_2) { "forall x y. (x = y ==> y = x)".to_formula }
  let(:axiom_3) { "forall x y z. (x = y /\\ y = x ==> x = z)".to_formula }
  let(:valudation) { {} }
  let(:func) { ->(f, args) {} }
  let(:empty) {
    ->(p, args) { if p == '=' then false else fail "undefined predicate #{p}" end }
  }
  let(:universal) {
    ->(p, args) { if p == '=' then true else fail "undefined predicate #{p}" end }
  }
  let(:equality) {
    ->(p, args) { if p == '=' then args.inject(:==) else fail "undefined predicate #{p}" end }
  }
  let(:even_sum) {
    ->(p, args) { if p == '=' then args.inject(:+).even? else fail "undefined predicate #{p}" end }
  }
  let(:modular_aritmetic_realation) {
    ->(p, args) { if p == '=' then args[0] == (args[1] % 16) else fail "undefined predicate #{p}" end }
  }

  def test_parse_first_axiom
    refute axiom_1.nil?
  end
  
  def test_parse_second_axiom
    refute axiom_2.nil?
  end

  def test_parse_thrird_axiom
    refute axiom_3.nil?
  end

  def test_axiom_1_empty
    refute axiom_1.holds?(domain, func, empty, valudation)
  end

  def test_axiom_1_universal
    assert axiom_1.holds?(domain, func, universal, valudation)
  end

  def test_axiom_1_equality
    assert axiom_1.holds?(domain, func, equality, valudation)
  end
  
  def test_axiom_1_even_sum
    assert axiom_1.holds?(domain, func, even_sum, valudation)
  end

  def test_axiom_1_modular_aritmetic_relation
    refute axiom_1.holds?(domain, func, modular_aritmetic_realation, valudation)
  end

  def test_axiom_2_empty
    assert axiom_2.holds?(domain, func, empty, valudation)
  end

  def test_axiom_2_universal
    assert axiom_2.holds?(domain, func, universal, valudation)
  end

  def test_axiom_2_equality
    assert axiom_2.holds?(domain, func, equality, valudation)
  end
  
  def test_axiom_2_even_sum
    assert axiom_2.holds?(domain, func, even_sum, valudation)
  end

  def test_axiom_2_modular_aritmetic_relation
    refute axiom_2.holds?(domain, func, modular_aritmetic_realation, valudation)
  end

  def test_axiom_3_empty
    assert axiom_3.holds?(domain, func, empty, valudation)
  end

  def test_axiom_3_universal
    assert axiom_3.holds?(domain, func, universal, valudation)
  end

  def test_axiom_3_equality
    refute axiom_3.holds?(domain, func, equality, valudation)
  end
  
  def test_axiom_3_even_sum
    refute axiom_3.holds?(domain, func, even_sum, valudation)
  end

  def test_axiom_3_modular_aritmetic_relation
    refute axiom_3.holds?(domain, func, modular_aritmetic_realation, valudation)
  end
end
