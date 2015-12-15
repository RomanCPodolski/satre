# A parster for propositional statements
# and simple mathematical expressions
module Parser
  # A propositional formula
  class Formula
    attr_reader :a

    def initialize(a)
      fail ArgumentError 'Argument must be a String' unless a.is_a?(String)
      @a = a.dup.freeze
    end

    def to_s
      a
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
