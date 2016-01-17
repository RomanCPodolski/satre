require 'satre/formula/first_order_logic/fol_formula'

module Satre
  class Relation < Fol_Formula
    attr_reader :relation
    attr_reader :term_list

    def initialize(relation, term_list)
      @relation = relation.dup.freeze
      @term_list = term_list.dup.freeze
    end

    def to_s
      s = term_list.map(&:to_s).join(relation.to_s)
      if s.to_s == '' then relation.to_s else s end
    end

  end
end
