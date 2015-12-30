require 'satre/formula'

module Satre
  class True < Formula
    def initialize
      super '⊤'
    end

    def eval(*)
      true
    end

    def atoms
      []
    end
  end
end
