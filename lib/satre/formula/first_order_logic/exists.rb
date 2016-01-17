require 'satre/formula/first_order_logic/fol_formula'

module Satre
  class Exists < Fol_Formula
    attr_reader :variable
    attr_reader :term

    def initialize(variable, term)
      #fail(ArgumentError, '...') unless variable.is_a?(Formula)
      #fail(ArgumentError, '...') unless term.is_a?(Formula)
      @variable = variable.dup.freeze
      @term = term.dup.freeze
    end

    def to_s
      "∃ #{variable}. #{term}"
    end
  end
end
