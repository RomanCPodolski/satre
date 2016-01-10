require 'satre/formula'

# A parster for propositional statements
# and simple mathematical expressions
module Satre
  # A propositional logic 'and' value
  class Entails < Formula
    attr_reader :p
    attr_reader :q

    def initialize(p,q)
      fail(ArgumentError, 'Argument must be a Formula') unless p.is_a?(Formula)
      fail(ArgumentError, 'Argument must be a Formula') unless q.is_a?(Formula)
      @p = p.dup.freeze
      @q = q.dup.freeze
      super "(#{@p} ⊨ #{@q})"
    end

    def eval(*)
      p.entails?(q) 
    end

    def atoms
      atoms = p.atoms + q.atoms
      atoms.uniq || []
    end

  end
end
