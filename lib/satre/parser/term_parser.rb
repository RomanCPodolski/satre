require 'satre/parser/parser'

module Satre
  class TermParser < Parser
    class << self

      # vs: set of bounds variables in the current scope
      # inp: current input 
      def parse_atomic_term(vs, inp)
        fail(ArgumentError, 'Term expected') if inp == []
        head = inp.first
        rest = inp[1..-1]
        if head == '(' then parse_bracketed(method(:parse_term).curry.call(vs), ")", rest)
        elsif head == '-' then papply( ->(t) { Function.new("-", [t])}, method(:parse_atomic_term).curry.call(vs), rest )
        elsif Lexer.alpanumeric?(head) && rest[0] == '('
          if rest[1] == ')'
            papply( -> { Function.new(head, []) }, rest[2..-1])
          else
            ast, rest = parse_bracketed(parse_list(',').call(method(:parse_term).curry.call(vs)) , ')', rest[1..-1])
            papply(->(args) { Function.new(head, args) }, ast, rest)
          end
        else
          a = if is_const_name(head) && !vs.include?(head) then Function.new(head,[]) else Variable.new(head) end
          return a, rest
        end
      end

      # build up parsing of general terms via parsing of the various infix operations
      def parse_term(vs, inp)
        colon = parse_right_infix("::", ->(e1,e2) { Function.new('::', [e1, e2]) })
        plus = parse_right_infix("+", ->(e1,e2) { Function.new('+', [e1, e2]) })
        minus = parse_left_infix("-", ->(e1,e2) { Function.new('-', [e1, e2]) })
        mul = parse_right_infix("*", ->(e1,e2) { Function.new('*', [e1, e2]) })
        div = parse_left_infix("/", ->(e1,e2) { Function.new('/', [e1, e2]) })
        power = parse_left_infix("^", ->(e1,e2) { Function.new('^', [e1, e2]) })
        atom = method(:parse_atomic_term).curry.call(vs)
        colon.call(plus.call(minus.call(mul.call(div.call(power.call(atom))))), inp)
      end

      def is_const_name(string)
        string.split('').all? { |c| Lexer.numeric?(c)  } || string.nil?
      end
      

      def parse_atom(vs, inp)
        parse_infix_atom(vs, inp)
        rescue ParserError
          head = inp.first
          rest = inp[1..-1]
          if rest[0] == '('
            rest = rest[1..-1]
            if rest[0] == ')' 
              return Atom.new(Relation.new(head, [])), rest[1..-1]
            else
              ast, rest = parse_bracketed(parse_list(',').call(method(:parse_term).curry.call(vs)),')', rest)
              papply( ->(args) { Atom.new(Relation.new(head,args))}, ast, rest)
            end
          else
            return Atom.new(Relation.new(head, [])), rest if head != '('
            fail(ParserError, 'Parse Atom')
          end
      end

      def parse_formula(ifn, afn, vs, inp)
        parse_Entails = parse_right_infix("|=", ->(p,q) { Entails.new(p,q)})
        parse_Iff = parse_right_infix("<=>", ->(p,q) { Iff.new(p,q)})
        parse_Imp = parse_right_infix("==>", ->(p,q) { Imp.new(p,q)})
        parse_Or = parse_right_infix("\\/", ->(p,q) { Or.new(p,q)})
        parse_And = parse_right_infix("/\\", ->(p,q) { And.new(p,q)})
        parse_Atom = method(:parse_atomic_formula).curry.call(ifn, afn, vs)
        parse_Entails.call(parse_Imp.call(parse_Or.call(parse_And.call(parse_Iff.call(parse_Atom)))),inp)
      end

      def parse(inp)
        make_parser(method(:parse_term).curry.call([]), inp)
      end
    end
  end
end

class String
  def to_term
    Satre::TermParser.parse(self)
  end
end
