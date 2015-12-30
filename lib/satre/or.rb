require 'satre/formula'

module Satre
  class Or < Formula
    attr_reader :p
    attr_reader :q

    def initialize(p,q)
      fail(ArgumentError, 'Argument must be a Formula') unless p.is_a?(Formula)
      fail(ArgumentError, 'Argument must be a Formula') unless q.is_a?(Formula)
      @p = p.dup.freeze
      @q = q.dup.freeze
      super "(#{@p} ∨ #{@q})"
    end

    def eval(valudation)
      p.eval(valudation) or q.eval(valudation)
    end

    def atoms
      atoms = p.atoms + q.atoms
      atoms.uniq || []
    end

    def self.parse(e)
      fail 'not yet implemented'
    end
  end
end
