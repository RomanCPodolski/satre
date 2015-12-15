require 'parser/formula'

# A parster for propositional statements
# and simple mathematical expressions
module Parser
  # A propositional 'True' value
  class True < Formula
    def initialize
      # super '⊤'
      super 'True'
    end

    def eval(v)
      true
    end

    def self.parse(e)
      fail 'not yet implemented'
    end
  end
end
