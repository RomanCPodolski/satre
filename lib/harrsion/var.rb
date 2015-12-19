require 'harrsion/expression'

# A parster for propositional statements
# and simple mathematical expressions
module Harrsion
  class Var < Expression
    def initialize(s)
      ArgumentError 's must be a string' unless s.is_a? String
      super "Var \"#{s}\""
    end

    def eval(v)
      fail 'not implemented'
    end

    def self.parse(e)
      fail 'not yet implemented'
    end
  end
end
