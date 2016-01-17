require 'satre/formula/fol/fol'

module Satre
  class Relation < Fol
    attr_reader :relation
    attr_reader :term_list

    def initialize(relation, term_list)
      @relation = relation.dup.freeze
      @term_list = term_list.dup.freeze
    end

    def to_s
      term_list.map(&:to_s).join(relation.to_s)
    end

  end
end
