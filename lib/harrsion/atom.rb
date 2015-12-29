require 'harrsion/formula'

# A parster for propositional statements
# and simple mathematical expressions
module Harrsion
  # A propositional 'atomic' value
  class Atom < Formula
    include Comparable
    
    def <=>(other)
      base <=> other.base
    end

    attr_reader :base

    def initialize(base)
      super base
    end

    def eval(valudation)
      fail(ParserError, 'valudation must be a hash') unless valudation.is_a?(Hash)
      fail(ParserError, 'all validations must be booleans') unless valudation.values.all?{|b|!!b == b}
      fail(Error, "valudation for Atom #{base} not given") unless valudation.keys.include?(base)
      valudation[base]
    end

    def atoms
      [base]
    end

    def self.parse(e)
      fail 'not yet implemented'
    end
  end
end
