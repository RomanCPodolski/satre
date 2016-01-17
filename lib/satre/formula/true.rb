require 'satre/formula'

module Satre
  class True < Formula

    def to_s
      '⊤'
    end

    def eval(*)
      true
    end

    def atoms
      []
    end
  end
end
