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

    # exists x. p is well-formed if p is well-formed
    def wellformed?(sig)
      term.wellformed?(sig)
    end

    # Exists(x,p) -> exists (fun a -> holds m ((x |-> a) v) p) domain;;
    def holds?(domain, func, pred, valudation)
      domain.any? do |a|
        valudation[variable.to_s.to_sym] = a
        term.holds?(domain, func, pred, valudation )
      end
    end

    def to_s
      "∃ #{variable}. #{term}"
    end
  end
end
