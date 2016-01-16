require 'satre/formula'

module Satre
  class Exists < Formula
    attr_reader :variable
    attr_reader :term

    def initialize(variable, term)
      #fail(ArgumentError, '...') unless variable.is_a?(Variable)
      #fail(ArgumentError, '...') unless term.is_a?(Term)
      @variable = variable.dup.freeze
      @term = term.dup.freeze
      super("(∃#{@variable}. #{@term})")
    end
  end
end
