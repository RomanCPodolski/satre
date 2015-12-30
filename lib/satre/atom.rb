require 'satre/formula'

# A parster for propositional statements
# and simple mathematical expressions
module Satre
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
      fail(Error, 'valudation must be a hash') unless valudation.is_a?(Hash)
      fail(Error, 'all validations must be booleans') unless valudation.values.all?{|b|!!b == b}
      fail(Error, "valudation for Atom #{base} not given") unless valudation.keys.include?(base)
      valudation[base]
    end

    def atoms
      [base]
    end

  end
end
