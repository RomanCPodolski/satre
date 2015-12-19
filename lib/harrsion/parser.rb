require 'harrsion/lexer'
require 'harrsion/and'
require 'harrsion/add'
require 'harrsion/mul'
require 'harrsion/const'
require 'harrsion/atom'
require 'harrsion/exists'
require 'harrsion/false'
require 'harrsion/forall'
require 'harrsion/formula'
require 'harrsion/iff'
require 'harrsion/imp'
require 'harrsion/not'
require 'harrsion/or'
require 'harrsion/true'
require 'harrsion/var'

module Harrsion
  class Parser
    class << self
      def make_parser
        lambda do |pfn, inp|
          expr, rest = pfn.call(Lexer.lex(inp))
          return expr if rest == []
          fail(ParserError, 'Unparsed input')
        end
      end
    end
  end

  class FormulaParser < Parser
    class << self
      def parse_formula
        lambda do |inp|
          e1, i1 = parse_iff(inp)
          if i1[0] == '<=>'
            e2, i2 = parse_formula.call(i1.drop(1))
            return Imp.new(e1,e2), i2
          end
          return e1, i1
        end
      end

      def parse_not(inp)
        if inp.first == '~'
          e1, i1 = parse_atom(inp.drop(1))
          return Not.new(e1), i1
        else
          e1, i1 = parse_atom(inp)
          return e1, i1
        end
      end

      def parse_and(inp)
        e1, i1 = parse_or(inp)
        if i1[0] == "\\/"
          e2, i2 = parse_formula.call(i1.drop(1))
          return And.new(e1,e2), i2
        end
        return e1, i1
      end

      def parse_or(inp)
        e1, i1 = parse_not(inp)
        if i1[0] == "/\\"
          e2, i2 = parse_formula.call(i1.drop(1))
          return Or.new(e1, e2), i2
        end
        return e1, i1
      end

      def parse_iff(inp)
        e1, i1 = parse_and(inp)
        if i1[0] == "=>"
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
          return Atom.new(inp[0]), inp.drop(1)
        end
      end

      def parse(inp)
        make_parser.curry.call(parse_formula).call(inp)
      end
    end
  end

  class ExpressionParser < Parser
    class << self
      def parse_expression
        lambda do |inp| 
          e1, i1 = parse_product(inp) 
          if i1[0] == '+' 
            e2, i2 = parse_expression.call(i1.drop(1))
            return Add.new(e1, e2), i2
          end
          return e1, i1
        end
      end

      def parse_product(inp)
        e1, i1 = parse_atom(inp)
        if i1[0] == '*' 
          e2,i2 = parse_expression.call(i1.drop(1))
          return Mul.new(e1, e2), i2
        end
        return e1, i1
      end

      def parse_atom(inp)
        fail(ArgumentError, 'Expected an expression at end of input') if inp == []
        if inp[0] == '('
          e2, i2 = parse_expression.call(inp.drop(1))
          if i2[0] == ')'
            return e2, i2.drop(1)
          else
            fail(ExpressionError, 'Expected closing bracket')
          end
        else
          if Lexer.numeric?.call(inp[0])
            return Const.new(inp[0].to_i), inp.drop(1)
          else
            return Var.new(inp[0]), inp.drop(1)
          end
        end
      end

      def parse(inp)
        make_parser.curry.call(parse_expression).call(inp)
      end
    end

  end
end

