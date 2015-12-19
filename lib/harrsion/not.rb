require 'Harrsion/formula'

# A parster for propositional statements
# and simple mathematical expressions
module Harrsion
  # A propositional negation
  class Not < Formula
    attr_reader :p

    def initialize(p)
      fail(ArgumentError, 'Argument must be a Formula') unless p.is_a?(Formula)
      @p = p.dup.freeze
      super "~(#{@p})"
    end

    def eval(v)
      not p.eval(v)
    end

    def self.parse(e)
      fail 'not yet implemented'
    end
  end
end
