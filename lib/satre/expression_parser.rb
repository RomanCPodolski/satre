module Satre
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

class String
  def to_expression
    Satre::ExpressionParser.parse(self)
  end
end
