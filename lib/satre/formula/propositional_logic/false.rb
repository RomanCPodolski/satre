require 'satre/formula'

module Satre
  class False < Formula

    def to_s
      '⊥'
    end

    alias :holds? :eval

    # False is well-formed
    def wellformed?(sig)
      true
    end

    def eval(*)
      false
    end

    def atoms
      []
    end

  end
end
