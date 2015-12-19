require 'harrsion/formula'

# A parster for propositional statements
# and simple mathematical expressions
module Harrsion
  # A propositional logic 'and' value
  class And < Formula
    attr_reader :p
    attr_reader :q

    def initialize(p,q)
      fail(ArgumentError, 'Argument must be a Formula') unless p.is_a?(Formula)
      fail(ArgumentError, 'Argument must be a Formula') unless q.is_a?(Formula)
      @p = p.dup.freeze
      @q = q.dup.freeze
      super "#{@p} /\\ #{@q}"
    end

    def eval(v)
      p.eval(v) && q.eval(v)
    end

    def self.parse(e)
      fail 'not yet implemented'
    end
  end
end
