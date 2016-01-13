require 'satre/formula'

module Satre
  class Not < Formula
    attr_reader :literal

    def initialize(literal)
      fail(ArgumentError, 'Argument must be a Formula') unless literal.is_a?(Formula)
      @literal = literal.dup.freeze
      super "(¬#{@literal})"
    end

    def eval(valudation)
      ! literal.eval(valudation)
    end

    def atoms
      literal.atoms || []
    end

  end
end
