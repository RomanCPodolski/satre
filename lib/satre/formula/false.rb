require 'satre/formula'

module Satre
  class False < Formula

    def to_s
      '⊥'
    end

    def eval(*)
      false
    end

    def atoms
      []
    end

  end
end
