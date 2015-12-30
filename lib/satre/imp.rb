require 'satre/formula'

module Satre
  class Imp < Formula
    attr_reader :p
    attr_reader :q

    def initialize(p,q)
      fail(ArgumentError, "Argument must be a Formula p:#{p}") unless p.is_a?(Formula)
      fail(ArgumentError, "Argument must be a Formula q:#{q}") unless q.is_a?(Formula)
      @p = p.dup.freeze
      @q = q.dup.freeze
      super "(#{@p} ⇔ #{@q})"
    end

    def eval(valudation)
      not(p.eval(valudation)) or (q.eval(valudation))
    end

    def atoms
      atoms = p.atoms + q.atoms
      atoms.uniq || []
    end
  end
end
