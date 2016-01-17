require 'satre/formula'

# A parster for propositional statements
# and simple mathematical expressions
module Satre
  # A propositional logic 'and' value
  class Entails < Formula
    attr_reader :knowledge_base
    attr_reader :logical_consequence

    def initialize(knowledge_base, logical_consequence)
      fail(ArgumentError, 'Argument must be a Formula') unless knowledge_base.is_a?(Formula)
      fail(ArgumentError, 'Argument must be a Formula') unless logical_consequence.is_a?(Formula)
      @knowledge_base = knowledge_base.dup.freeze
      @logical_consequence = logical_consequence.dup.freeze
    end

    def to_s
      "(#{knowledge_base} ⊨ #{logical_consequence})"
    end

    # p |= q is wellformed if p and q are well-formed
    def wellformed?(sig)
      knowledge_base.wellformed?(sig) && logical_consequence.wellformed?(sig)
    end

    def hold?(domain, func, predicate, valudation)
      fail 'not implemented'
      #And.new(knowledge_base, Not.new(logical_consequence)).unsatifiable?
    end

    def eval(*)
      And.new(knowledge_base, Not.new(logical_consequence)).unsatifiable?
    end

    def atoms
      atoms = knowledge_base.atoms + logical_consequence.atoms
      atoms.uniq || []
    end

  end
end
