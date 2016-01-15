require 'test_helper'
class TermTest < Minitest::Test
  def test_term
    p Term.new("sqrt", [
      Term.new("-",[Term.new("1",[])]),
      Term.new("cos", [
        Term.new("power", [
          Term.new("+", [
            Variable.new("x"),
            Variable.new("y")
          ])
        ])
      ])
    ])
  end
end
