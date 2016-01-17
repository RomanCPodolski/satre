require 'satre/formula'

# A parster for propositional statements
# and simple mathematical expressions
module Satre
  # A propositional 'atomic' value
  class Atom < Formula
    
    attr_reader :value

    def initialize(value)
      @value = value.dup.freeze
    end

    def holds?(domain, func, predicate, valudation)
      fail(OperationExceprion, 'Atomic value must be a relation') unless value.is_a?(Relation)
      value.holds?(domain, func, predicate, valudation)
    end

    # A predicate p(x_1,...,x_n) is well-formed if
    #   (a) each term x_1,...,x_n is well-formed
    #   (b) there is a pair (q, m) in signature sig where q = p and n = m
    def wellformed?(sig)
      @value.wellformed?(sig)
    end

    def eval(valudation)
      fail(Error, 'valudation must be a hash') unless valudation.is_a?(Hash)
      fail(Error, 'all validations must be booleans') unless valudation.values.all?{|b|!!b == b}
      valudation = valudation.inject({}){|memo,(k,v)| memo[k.to_sym] = v; memo}
      fail(Error, "valudation for Atom #{value} not given") unless valudation.keys.include?(to_s.to_sym)
      valudation[to_s.to_sym]
    end
    
    def to_s
      value.to_s
    end

    def atoms
      [value.to_s.to_sym]
    end

  end
end
