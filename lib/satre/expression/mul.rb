require 'satre/expression'

# A parster for propositional statements
# and simple mathematical expressions
module Satre
  class Mul < Expression
    attr_reader :p
    attr_reader :q

    def initialize(p,q)
      fail(ArgumentError, 'p must be a expression') unless p.is_a?(Expression)
      fail(ArgumentError, 'q must be a expression') unless p.is_a?(Expression)
      @p = p.dup.freeze
      @q = q.dup.freeze
      super "Mul(#{@p},#{@q})"
    end

    def eval
      p.eval * q.eval
    end

    def self.parse(e)
      e1, i1 = Expression.parse(inp)
      if e1[-1] == '*'
        _e2,i2 = parse_expression(i1)
        return Mul.new(e1,i1), i2
      end
    end
  end
end
