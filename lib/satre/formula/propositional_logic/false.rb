require 'satre/formula'

module Satre
  class False < Formula

    def to_s
      '⊥'
    end

    alias :holds? :eval

    def eval(*)
      false
    end

    def atoms
      []
    end

  end
end
