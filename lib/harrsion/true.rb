require 'harrsion/formula'

# A parster for propositional statements
# and simple mathematical expressions
module Harrsion
  # A propositional 'True' value
  class True < Formula
    def initialize
      super '⊤'
    end

    def eval(_valudation)
      true
    end

    def atoms
      []
    end

    def self.parse(e)
      fail 'not yet implemented'
    end
  end
end
