require 'satre/formula'

module Satre
  class Or < Formula
    attr_reader :left_disjunct
    attr_reader :right_disjunct

    def initialize(left_disjunct, right_disjunct)
      fail(ArgumentError, 'Argument must be a Formula') unless left_disjunct.is_a?(Formula)
      fail(ArgumentError, 'Argument must be a Formula') unless right_disjunct.is_a?(Formula)
      @left_disjunct = left_disjunct.dup.freeze
      @right_disjunct = right_disjunct.dup.freeze
      super "(#{@left_disjunct} ∨ #{@right_disjunct})"
    end

    def eval(valudation)
      left_disjunct.eval(valudation) or right_disjunct.eval(valudation)
    end

    def atoms
      atoms = left_disjunct.atoms + right_disjunct.atoms
      atoms.uniq || []
    end
  end
end
