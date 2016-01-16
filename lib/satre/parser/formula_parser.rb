require 'satre/formula'

module Satre
  class FormulaParser < Parser
    class << self

      def parse_formula
        lambda do |inp|
          e1, i1 = parse_imp(inp)
          if i1[0] == '|=' or i1[0] == '⊨'
            e2, i2 = parse_formula.call(i1.drop(1))
            return Entails.new(e1,e2), i2
          end
          return e1, i1
        end
      end

      def parse_imp(inp)
        e1, i1 = parse_iff(inp)
        if i1[0] == '=>' or i1[0] == '→'
          e2, i2 = parse_formula.call(i1.drop(1))
          return Imp.new(e1,e2), i2
        end
        return e1, i1
      end
      
      def parse_not(inp)
        if inp.first == '~' or inp.first == '¬'
          e1, i1 = parse_atom(inp.drop(1))
          return Not.new(e1), i1
        else
          e1, i1 = parse_atom(inp)
          return e1, i1
        end
      end

      def parse_and(inp)
        e1, i1 = parse_or(inp)
        if i1[0] == '/\\' or i1[0] == '∧'
          e2, i2 = parse_formula.call(i1.drop(1))
          return And.new(e1,e2), i2
        end
        return e1, i1
      end

      def parse_or(inp)
        e1, i1 = parse_not(inp)
        if i1[0] == '\\/' or  i1[0] == '∨'
          e2, i2 = parse_formula.call(i1.drop(1))
          return Or.new(e1, e2), i2
        end
        return e1, i1
      end

      def parse_iff(inp)
        e1, i1 = parse_and(inp)
        if i1[0] == '<=>' or i1[0] == '⇔'
          e2, i2 = parse_formula.call(i1.drop(1))
          return Iff.new(e1, e2), i2
        end
        return e1, i1
      end

      def parse_atom(inp)
        fail(ArgumentError, 'Expected an expression at end of input') if inp == []
        if inp[0] == '('
          e2, i2 = parse_formula.call(inp.drop(1))
          if i2[0] == ')'
            return e2, i2.drop(1)
          else
            fail(ExpressionError, 'Expected closing bracket')
          end
        else
          return False.new, inp.drop(1) if inp[0] == "False"
          return True.new, inp.drop(1) if inp[0] == "True"
          return Atom.new(inp[0]), inp.drop(1)
        end
      end

      def parse(inp)
        method(:make_parser).curry.call(parse_formula).call(inp)
      end

    end
  end
end

class String
  def to_formula
    Satre::FormulaParser.parse(self)
  end
end
