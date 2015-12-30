module Satre
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
      fail 'abstract'
    end

    def simplify
      fail 'not yet implemented'
    end
  end
end
