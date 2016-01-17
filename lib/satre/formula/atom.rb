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

    def eval(valudation)
      fail(Error, 'valudation must be a hash') unless valudation.is_a?(Hash)
      fail(Error, 'all validations must be booleans') unless valudation.values.all?{|b|!!b == b}
      valudation = valudation.inject({}){|memo,(k,v)| memo[k.to_sym] = v; memo}
      fail(Error, "valudation for Atom #{base} not given") unless valudation.keys.include?(base.to_sym)
      valudation[base.to_sym]
    end
    
    def to_s
      value.to_s
    end

    def atoms
      [base]
    end

  end
end
