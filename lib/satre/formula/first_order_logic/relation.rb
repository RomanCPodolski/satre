require 'satre/formula/first_order_logic/fol_formula'

module Satre
  class Relation < Fol_Formula
    attr_reader :relation
    attr_reader :term_list

    def initialize(relation, term_list)
      @relation = relation.dup.freeze
      @term_list = term_list.dup.freeze
    end

    # A predicate p(x_1,...,x_n) is well-formed if
    #   (a) each term x_1,...,x_n is well-formed
    #   (b) there is a pair (q, m) in signature sig where q = p and n = m
    def wellformed?(sig)
      term_list.all? { |x| x.wellformed?(sig) } && sig[relation.to_sym] == term_list.length
    end

    def to_s
      return term_list.map(&:to_s).join(relation.to_s) if ['>','<','=','<=','>=','!='].include?(relation)
      s = term_list.map(&:to_s).join(',')
      "#{relation}#{"("+s+")" unless s.to_s == ''}"
    end
  end
end
