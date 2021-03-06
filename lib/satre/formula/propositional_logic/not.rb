require 'satre/formula'

module Satre
  class Not < Formula
    attr_reader :literal

    def initialize(literal)
      fail(ArgumentError, 'Argument must be a Formula') unless literal.is_a?(Formula)
      @literal = literal.dup.freeze
    end

    def to_s
      "(¬#{literal})"
    end

    def holds?(domain, func, pred, valudation)
      ! literal.holds?(domain, func, pred, valudation)
    end

    # ~p is well-formed if p is well-formed
    def wellformed?(sig)
      literal.wellformed?(sig)
    end

    def eval(valudation)
      ! literal.eval(valudation)
    end

    def atoms
      literal.atoms || []
    end

  end
end
