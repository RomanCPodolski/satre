# A parster for propositional statements
# and simple mathematical expressions
module Harrsion
  # A propositional formula
  class Formula
    attr_reader :base

    def initialize(base)
      fail(ArgumentError, 'Argument must be a String') unless base.is_a?(String)
      @base = base.dup.freeze
    end

    def to_s
      base
    end

    def eval(v)
      fail 'not yet implemented'
    end

    def self.parse(e)
      fail 'not yet implemented'
    end

    def simplify
      fail 'not yet implemented'
    end
  end
end
