require 'satre/formula'

module Satre
  class False < Formula

    def initialize
      super '⊥'
    end

    def eval(*)
      false
    end

    def atoms
      []
    end

  end
end
