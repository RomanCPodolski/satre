require 'parser/formula'

# A parster for propositional statements
# and simple mathematical expressions
module Parser
  # A propositional 'atomic' value
  class Atom < Formula
    def initialize(a)
      super a
    end

    def eval(v)
      v.call(a)
    end

    def self.parse(e)
      fail 'not yet implemented'
    end
  end
end
