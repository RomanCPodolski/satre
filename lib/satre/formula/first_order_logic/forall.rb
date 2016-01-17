require 'satre/formula/first_order_logic/fol_formula'

module Satre
  class Forall < Fol_Formula
    attr_reader :variable
    attr_reader :term

    def initialize(variable, term)
      #fail(ArgumentError, "Variable was #{variable.class}") unless variable.is_a?(Formula)
      #fail(ArgumentError, "Term was #{term.class}") unless term.is_a?(Formula)
      @variable = variable.dup.freeze
      @term = term.dup.freeze
    end
    
    # forall x. p is well-formed if p is well-formed
    def wellformed?(sig)
      term.wellformed?(sig)
    end

    def holds?(*args)
    #   | Forall(x,p) -> forall (fun a -> holds m ((x |-> a) v) p) domain
      false
    end
    
    def to_s
      "∀ #{variable}. #{term}"
    end
  end
end
