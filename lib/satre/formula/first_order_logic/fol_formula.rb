require 'satre/formula/formula'

module Satre
  class Fol_Formula < Formula

    # let rec holds (domain, func, pred as m) v fm =
    #   match fm with
    #     False -> false
    #   | True -> true
    #   | Atom(R(r,args)) -> pred r (map (termval m v) args)
    #   | Not(p) -> not(holds m v p)
    #   | And(p,q) -> (holds m v p) & (holds m v q)
    #   | Or(p,q) -> (holds m v p) or (holds m v q)
    #   | Imp(p,q) -> not(holds m v p) or (holds m v q)
    #   | Iff(p,q) -> (holds m v p = holds m v q)
    #   | Forall(x,p) -> forall (fun a -> holds m ((x |-> a) v) p) domain
    #   | Exists(x,p) -> exists (fun a -> holds m ((x |-> a) v) p) domani;;
    def holds?
      fail 'abstract method'
    end

    # 1. Constant True and False are wellformed
    # 2. Predicate $p(x_1, \dots, x_n)$ is well-formed if
    #    (a) Each term is $x_1, \dots, x_n$ is well formed
    #    (b) There is a pair (q, m) in signature sig q = p and n = m
    # 3. p //\ q is wellformed if p and q are wellformed
    # 4. p \// q is wellformed if p and q are wellformed
    # 5. p ==> q is wellformed if p and q are wellformed
    # 6. p <=> q is wellformed if p and q are wellformed
    # 7. forall x. p and exists x. p are wellformed if p is wellformed
    def wellformed?(signature)
      fail 'abstract method'
    end
  end
end
