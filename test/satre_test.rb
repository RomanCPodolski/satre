require 'test_helper'

class SatreTest < Minitest::Test

  def test_that_it_has_a_version_number
    refute_nil ::Satre::VERSION
  end

  def test_exercise_4_1_1
    assert('False |= True'.to_formula.eval)
  end

  def test_exercise_4_1_2
    refute('True |= False'.to_formula.eval)
  end

  def test_exercise_4_1_3
    assert('(A /\\ B) |= (A <=> B)'.to_formula.eval)
  end

  def test_exercise_4_1_4
    refute('(A <=> B) |= A \\/ B'.to_formula.eval)
  end

  def test_exercise_4_1_5
    assert('(A <=> B) |= ~A \\/ B'.to_formula.eval)
  end

  def test_exercise_4_2_1
    assert('Smoke => Smoke'.to_formula.tautology?)
    assert('Smoke => Smoke'.to_formula.satifiable?)
    refute('Smoke => Smoke'.to_formula.unsatifiable?)
  end

  def test_exercise_4_2_2
    assert('(Smoke => Fire) => (~Smoke => ~Fire)'.to_formula.tautology?)
    assert('(Smoke => Fire) => (~Smoke => ~Fire)'.to_formula.satifiable?)
    refute('(Smoke => Fire) => (~Smoke => ~Fire)'.to_formula.unsatifiable?)
  end

  def test_exercise_4_2_3
    assert('Smoke \\/ Fire \\/ ~Fire'.to_formula.tautology?)
    assert('Smoke \\/ Fire \\/ ~Fire'.to_formula.satifiable?)
    refute('Smoke \\/ Fire \\/ ~Fire'.to_formula.unsatifiable?)
  end

  def test_exercise_4_2_4
    refute('(Fire => Smoke) /\\ Fire /\\ ~Smoke'.to_formula.tautology?)
    refute('(Fire => Smoke) /\\ Fire /\\ ~Smoke'.to_formula.satifiable?)
    assert('(Fire => Smoke) /\\ Fire /\\ ~Smoke'.to_formula.unsatifiable?)
  end

  def test_exercise_4_3_1
    skip "I first need to understand what are knights and knaves"
  end

end
