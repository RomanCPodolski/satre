require 'satre/formula'

module Satre
  class Iff < Formula
    attr_reader :left_conditional
    attr_reader :right_conditional

    def initialize(left_conditional, right_conditional)
      fail(ArgumentError, 'Argument must be a Formula') unless left_conditional.is_a?(Formula)
      fail(ArgumentError, 'Argument must be a Formula') unless right_conditional.is_a?(Formula)
      @left_conditional = left_conditional.dup.freeze
      @right_conditional = right_conditional.dup.freeze
    end

    def to_s
      "(#{left_conditional} ⇔ #{right_conditional})"
    end

    def eval(valudation)
      left_conditional.eval(valudation) == right_conditional.eval(valudation)
    end

    def atoms
      atoms = left_conditional.atoms + right_conditional.atoms
      atoms.uniq || []
    end
  end
end

