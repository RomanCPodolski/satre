require 'satre/formula/term/term'

module Satre
  class Variable < Term
    attr_reader :variable

    def initialize(variable)
      @variable = variable.dup.freeze
    end

    # A variable is well-formed
    def wellformed?(_)
      true
    end

    def validate(domain, func, m, v, tm)
    #     Var(x) -> apply v x
      v.send(variable) # ?
    end

    def to_s
      variable.to_s
    end
  end
end
