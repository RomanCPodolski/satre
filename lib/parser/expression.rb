# A parster for propositional statements
# and simple mathematical expressions
module Parser
  class Expression
    attr_reader :base

    def initialize(b)
      fail ArgumentError 'argument must be a string' unless b.is_a?(String)
      @base = b.dup.freeze
    end

    def to_s
      base
    end

    def eval(fun, *args)
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
