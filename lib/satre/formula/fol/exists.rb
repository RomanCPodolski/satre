require 'satre/formula'

module Satre
  class Exists < Formula
    attr_reader :variable
    attr_reader :term

    def initialize(variable, term)
      #fail(ArgumentError, '...') unless variable.is_a?(Formula)
      #fail(ArgumentError, '...') unless term.is_a?(Formula)
      @variable = variable.dup.freeze
      @term = term.dup.freeze
    end

    def to_s
      "∃ #{variable}. #{term}"
    end
  end
end
