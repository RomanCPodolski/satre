require 'satre/parser/parser'

module Satre
  class FormulaParser < Parser
    class << self

      def parse_formula(ifn, afn, vs, inp)
        parse_Entails = parse_right_infix("|=", ->(p,q) { Entails.new(p,q)})
        parse_Iff = parse_right_infix("<=>", ->(p,q) { Iff.new(p,q)})
        parse_Imp = parse_right_infix("==>", ->(p,q) { Imp.new(p,q)})
        parse_Or = parse_right_infix("\\/", ->(p,q) { Or.new(p,q)})
        parse_And = parse_right_infix("/\\", ->(p,q) { And.new(p,q)})
        parse_Atom = method(:parse_atomic_formula).curry.call(ifn, afn, vs)
        parse_Entails.call(parse_Imp.call(parse_Or.call(parse_And.call(parse_Iff.call(parse_Atom)))),inp)
      end

      # absorbs the list of variables allowing the convention of
      # repeated quantifiers
      def parse_quant(ifn, afn, vs, qcon, x, inp)
        fail(ArgumentError, 'Body of quantified term expected') if inp == []
        head = inp.first
        rest = inp[1..-1]
        ast, rest = if head == '.' then parse_formula(ifn, afn, vs, rest) else parse_quant(ifn, afn, vs.push(head), qcon, head, rest) end
        papply( ->(fm) { qcon.call(x,fm) }, ast, rest )
      end

      # ifn: restricted parser for infix atoms
      # afn: more general parser for arbitary atoms
      def parse_atomic_formula(ifn, afn, vs, inp)
        fail(ArgumentError, 'Expected an formula at end of input') if inp == []
        head = inp.first
        rest = inp[1..-1]
        case head 
        when "false" then return False.new, rest
        when "true" then return True.new, rest
        when "(" 
          begin
            ifn.call(vs, inp)
          rescue
            parse_bracketed(method(:parse_formula).curry.call(ifn, afn, vs), ")", rest)
          end
        when "~"
          ast, rest = parse_atomic_formula(ifn, afn, vs, rest)
          papply(->(p) { Not.new(p) }, ast, rest)
        when "forall" then 
          parse_quant(ifn, afn, vs.push(rest[0]), ->(x,p) { Forall.new(x,p) }, rest[0], rest[1..-1])
        when "exists" then parse_quant(ifn, afn, vs.push(rest[0]), ->(x,p) { Exists.new(x,p) }, rest[0], rest[1..-1])
        else afn.call(vs, inp)
        end
      end

      def parse_infix_atom(vs, inp)
        tm, rest = TermParser.parse_term(vs, inp)
        if rest != [] && ["=", '<', '<=', '>', ">="].include?(rest.first)
          ast, ost = TermParser.parse_term(vs, rest[1..-1])
          papply( ->(tm_) {Atom.new(Relation.new(rest[0], [tm, tm_]))  }, ast, ost )
        else fail ParserError, 'calculated' # Excepion erfinden
        end
      end

      def parse(inp)
        make_parser(method(:parse_formula).curry.call(method(:parse_infix_atom),
          TermParser.method(:parse_atom), []), inp)
      end

    end
  end
end

class String
  def to_formula
    Satre::FormulaParser.parse(self)
  end
end
