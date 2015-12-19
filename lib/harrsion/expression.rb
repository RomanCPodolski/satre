# A parster for propositional statements
# and simple mathematical expressions
module Harrsion
  class Expression
    attr_reader :base

    def initialize(base)
      fail(ArgumentError, 'argument must be a string') unless base.is_a?(String)
      @base = base.dup.freeze
    end

    def to_s
      base
    end

    def eval # abstract method
    end

    #def self.parse(inp)
      #e1,i1 = Mul.parse(inp) 
      #if e1[-1] == '+'
        #_e2, _i2 = parse_expression(i1)
        #return Add.new(e1,i1),i2
      #end
    #end

    def simplify
      fail 'not yet implemented'
    end
  end
end
