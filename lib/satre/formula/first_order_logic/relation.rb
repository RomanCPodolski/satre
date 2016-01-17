require 'satre/formula/first_order_logic/fol_formula'

module Satre
  # A first-order-logig relation between terms
  #
  # Typical relations are
  #   p > q - term p is greater than term p
  #   p < q - term p is less than term p
  #   p = q - term p is equvivalent to term p
  #   p >= q - term p is greter or equvivalent to term q
  #   p <= q - term p is less or equvivalent to term q
  #   p != q - term p is not equvivalent to term q
  class Relation < Fol_Formula
    attr_reader :relation
    attr_reader :term_list

    def initialize(relation, term_list)
      @relation = relation.dup.freeze
      @term_list = term_list.dup.freeze
    end

    def holds?(domain, func, predicate, valudation)
      predicate.call(relation, term_list.map { |t| t.validate(func, predicate, valudation) })
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
