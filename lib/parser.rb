require 'parser/lexer'
require 'parser/and'
require 'parser/atom'
require 'parser/exists'
require 'parser/false'
require 'parser/forall'
require 'parser/formula'
require 'parser/iff'
require 'parser/imp'
require 'parser/not'
require 'parser/or'
require 'parser/true'

module Parser
  module ClassMethods
    
    # let rec parse_expression i =
    #   match parse_product i with
    #     e1,"+"::i1 -> let e2,i2 = parse_expression i1 in Add(e1,i1),i2
    #   | e1,i1 -> e1,i1
    def parse_expression(e)
      fail 'not yet implemented'
    end

    # let rec parse_product i =
    #   match parse_atom i with
    #     e1,"*"::i1 -> let e2,i2 = parse_expression i1 in Mul(e1,i1),i2
    #   | e1,i1 -> e1,i1
    def parse_product(e)
      fail 'not yet implemented'
    end

    # let parse_atom i =
    #   match i with
    #     [] -> failwith "Expected an expression at en of input"
    #   | "("::i1 -> (match parse_expression i1 with
    #                   e2,")"::i2 -> e2,i2
    #                 | _ -> failwith "Exprected closing bracket")
    #   | tok::i1 -> if forall numeric (explode tok)
    #                then Const(int_of_string tok),i1
    #                else Var(tok),i1;;
    def parse_atom(e)
      fail ArgumentError 'Expected an expression at end of input' if e == []
    end

    def make_parser(pfn, s)
      fail 'not yet implemented'
    end

    def parse_formula(f)
      fail 'not yet implemented'
    end

    def parse_and(f)
      fail 'not yet implemented'
    end

    def parse_or(f)
      fail 'not yet implemented'
    end

    def parse_iff(f)
      fail 'not yet implemented'
    end

    def parse_imp(f)
      fail 'not yet implemented'
    end
  end

  module InstanceMethods

  end

  def self.included(receiver)
    receiver.extend         ClassMethods
    receiver.send :include, InstanceMethods
  end
end
