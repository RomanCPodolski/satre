require 'parser/formula'

# A parster for propositional statements
# and simple mathematical expressions
module Parser
  # A propositional 'False' value
  class False < Formula
    def initialize
      # super '⊥'
      super 'False'
    end

    def eval(*)
      false
    end

    def self.parse(e)
      fail 'not yet implemented'
    end
  end
end
