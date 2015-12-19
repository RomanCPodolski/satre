require 'harrsion/formula'

# A parster for propositional statements
# and simple mathematical expressions
module Harrsion
  # A propositional 'atomic' value
  class Atom < Formula

    attr_reader :base

    def initialize(base)
      super base
    end

    def eval(v)
      v.call(base)
    end

    def self.parse(e)
      fail 'not yet implemented'
    end
  end
end
