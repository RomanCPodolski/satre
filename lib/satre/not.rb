require 'satre/formula'

module Satre
  class Not < Formula
    attr_reader :p

    def initialize(p)
      fail(ArgumentError, 'Argument must be a Formula') unless p.is_a?(Formula)
      @p = p.dup.freeze
      super "¬#{@p}"
    end

    def eval(valudation)
      not p.eval(valudation)
    end

    def atoms
      p.atoms || []
    end

  end
end
