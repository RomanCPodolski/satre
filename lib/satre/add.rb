require 'satre/expression'

# A parster for propositional statements
# and simple mathematical expressions
module Satre
  class Add < Expression
    attr_reader :p
    attr_reader :q

    def initialize(p,q)
      fail(ArgumentError, 'p must be a expression') unless p.is_a?(Expression)
      fail(ArgumentError, 'q must be a expression') unless p.is_a?(Expression)
      @p = p.dup.freeze
      @q = q.dup.freeze
      super "Add (#{@p},#{@q})"
    end

    def eval
      p.eval + q.eval
    end

    def self.parse(e)
      fail 'not yet implemented'
    end
  end
end
