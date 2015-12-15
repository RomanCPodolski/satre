require 'parser/expression'

# A parster for propositional statements
# and simple mathematical expressions
module Parser
  class Add < Expression
    attr_reader :p
    attr_reader :q

    def initialize(p,q)
      ArgumentError 'p must be a expression' unless p.is_a?(Expression)
      ArgumentError 'q must be a expression' unless p.is_a?(Expression)
      @p = p.dup.freeze
      @q = q.dup.freeze
      super "Add (#{@p},#{@q})"
    end

    def eval
      # super(:+, p.eval, q.eval)
      p.eval + q.eval
    end

    def self.parse(e)
      fail 'not yet implemented'
    end
  end
end
