require 'parser/formula'

# A parster for propositional statements
# and simple mathematical expressions
module Parser
  # A propositional logical 'exits'
  class Exists < Formula
    attr_reader :string
    attr_reader :p

    def initialize(s, p)
      fail ArgumentError 'Argument must be a String' unless s.is_a?(String)
      fail ArgumentError 'Argument must be a Formula' unless q.is_a?(Formula)
      @string = s.dup.freeze
      @p = p.dup.freeze
      # super p.a + ' ∀' + @string
      super "#{@p} Exists: #{@string}"
    end

    def eval(v)
      fail 'not implemented'
    end

    def self.parse(e)
      fail 'not yet implemented'
    end
  end
end
