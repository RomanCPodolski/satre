require 'satre/formula/term/term'

module Satre
  class Variable < Term
    def initialize(variable)
      super(variable, [])
    end

    def to_s
      "#{function}"
    end
  end
end
