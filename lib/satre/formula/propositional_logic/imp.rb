require 'satre/formula'

module Satre
  class Imp < Formula
    attr_reader :antendence
    attr_reader :consequence

    def initialize(antendence, consequence)
      fail(ArgumentError, "Argument must be a Formula p:#{p}") unless antendence.is_a?(Formula)
      fail(ArgumentError, "Argument must be a Formula q:#{q}") unless consequence.is_a?(Formula)
      @antendence = antendence.dup.freeze
      @consequence = consequence.dup.freeze
    end

    def to_s
      "(#{antendence} → #{consequence})"
    end

    # p ==> q is well-formed if p and q are well-formed
    def wellformed?(sig)
      antendence.wellformed?(sig) && consequence.wellformed?(sig)
    end

    def holds(*args)
      (! antendence.holds?(args)) or (consequence.holds?(args))
    end

    def eval(valudation)
      (! antendence.eval(valudation)) or (consequence.eval(valudation))
    end

    def atoms
      atoms = antendence.atoms + consequence.atoms
      atoms.uniq || []
    end
  end
end
