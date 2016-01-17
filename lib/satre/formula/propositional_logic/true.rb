require 'satre/formula'

module Satre
  class True < Formula

    def to_s
      '⊤'
    end

    # true holds
    alias :holds? :eval

    # True is wellformed
    def wellformed?(_)
      true
    end

    def eval(*)
      true
    end

    def atoms
      []
    end
  end
end
