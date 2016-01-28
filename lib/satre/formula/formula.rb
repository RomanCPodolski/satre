module Satre
  class Formula
    include Comparable
    
    def <=>(other)
      self.to_s <=> other.to_s
    end

    def atoms
      fail 'abstract'
    end

    def on_all_valuations?
      truthtable = [true, false].repeated_permutation(self.atoms.size).map do |args|
        self.atoms.zip(args).to_h
      end
      truthtable.all? { |v| self.eval(v) }
    end

    def eval(_valudation)
      fail 'abstract'
    end

    def tautology?
      on_all_valuations?
    end

    def unsatifiable?
      Not.new(self).tautology?
    end

    def satifiable?
      not unsatifiable?
    end

    def entails?(other)
      And.new(self, Not.new(other)).unsatifiable?
    end

  end
end
