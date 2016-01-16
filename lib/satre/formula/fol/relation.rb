require 'satre/formula'

module Satre
  class Relation < Formula
    attr_reader :relation
    attr_reader :term_list

    def initialize(relation, term_list)
      @relation = relation.dup.freeze
      @term_list = term_list.dup.freeze
      super("#{relation}#{term_list unless term_list == []}")
    end

    def holds?
      false
    end
  end
end