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
