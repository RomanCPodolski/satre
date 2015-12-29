# A parster for propositional statements
# and simple mathematical expressions
module Harrsion
  # A propositional formula
  class Formula
    attr_reader :base

    def initialize(base)
      fail(ArgumentError, 'Argument must be a String') unless base.is_a?(String)
      @base = base.dup.freeze
    end

    def to_s
      base
    end

    def atoms
      fail 'abstract'
    end

    def on_all_valuations?
      valudation = Hash[self.atoms.map { |x| [x, true] }]
      truthtable = [valudation]
      valudation.length.times do |i|
        v = {}
        (valudation.length - i).times do |j| 
          v = valudation.dup
          v[v.keys[j]] = ! v[v.keys[j]]
          truthtable << v
        end
        valudation = v
      end
      truthtable.all? { |v| self.eval(v) }
    end

    def eval(_valudation)
      fail 'abstract'
    end

    def tautology?
      # TODO: now
      fail 'not yet implemented'
    end

    def unsatifiable?
      # TODO: now
      fail 'not yet implemented'
    end

    def satifiable?
      # TODO: now
      fail 'not yet implemented'
    end

    def entails?
      # TODO: now
      fail 'not yet implemented'
    end

  end
end
