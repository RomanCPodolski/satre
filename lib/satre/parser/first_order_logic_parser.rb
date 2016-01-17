require 'satre/parser/parser'
require 'satre/formula'
require 'satre/formula/fol/relation'

# First draft
module Satre
  class FirstOrderLogicParser < Parser
    class << self
      ###
      # Generic parsing function
      # sof: function -> takes the current input and combines it in some way with the items arravied at so far
      # opupdate: function -> modifies the function appropriately when an new item is parsed.
      ###
      def parse_ginfix(opsym, opupdate, sof, subparser, inp)
        e1, inp1 = subparser.call(inp)
        if inp1 != [] && inp1[0] == opsym
          parse_ginfix(opsym, opupdate, opupdate.curry.call(sof, e1), subparser, inp1[1..-1])
        else
          return sof.call(e1), inp1
        end
      end

      # parse a list of items and combine them in a left associated manner
      # returns a lambda
      def parse_left_infix(opsym, opcon)
        opupdate = ->(f, e1 ,e2) {opcon.call(f.call(e1), e2) }
        sof = ->(x) { x }
        method(:parse_ginfix).curry.call(opsym, opupdate, sof)
      end

      # parse a list of items and combine them in a right associated manner
      # returns a lambda
      def parse_right_infix(opsym, opcon)
        opupdate = ->(f,e1,e2) { f.call(opcon.call(e1,e2)) }
        sof = ->(x) { x }
        method(:parse_ginfix).curry.call(opsym, opupdate, sof)
      end

      # parse a list of items and collect them in a list
      def parse_list(opsym)
        opupdate = ->(f,e1,e2) { f.call(e1) + e2 }
        sof = ->(x) { [x] }
        method(:parse_ginfix).curry.call(opsym, opupdate, sof)
      end

      # Applies a function to the first element of a pair.
      # The idea being to modify the returned abstract syntax tree while leaving
      # the `unparsed input` alone
      def papply(f, ast, rest)
        return f.call(ast), rest
      end

      # Checks if the head of a list (typically the list of unparsed input)
      # is some particular item, but also first checks that the list is nonempty
      # before looking at its head
      def nextin(inp, tok)
        inp != [] && inp.first == tok
      end

      # Deals with the common situation of syntastic items enclosed in brackets
      # It simply calls the subparser and  then checks and eliminates
      # the closing bracket. In principle, the therminating character can be anything,
      # so this function could equally be used for other purposes.
      def parse_bracketed(subparser, closing_character, inp)
        ast, rest = subparser.call(inp)
        return ast, rest[1..-1] if nextin(rest, closing_character)
        fail(ExpressionError, "Expected closing character '#{closing_character}'")
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
      
      def parse_infix_atom(vs, inp)
        tm, rest = parse_term(vs, inp)
        if rest != [] && ["=", '<', '<=', '>', ">="].include?(rest.first)
          ast, ost = parse_term(vs, rest[1..-1])
          papply( ->(tm_) {Atom.new(Relation.new(rest[0], [tm, tm_]))  }, ast, ost )
        else fail ParserError, 'calculated' # Excepion erfinden
        end
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
        parse_Iff = parse_right_infix("<=>", ->(p,q) { Iff.new(p,q)})
        parse_Imp = parse_right_infix("==>", ->(p,q) { Imp.new(p,q)})
        parse_Or = parse_right_infix("\\/", ->(p,q) { Or.new(p,q)})
        parse_And = parse_right_infix("/\\", ->(p,q) { And.new(p,q)})
        parse_Atom = method(:parse_atomic_formula).curry.call(ifn, afn, vs)
        parse_Iff.call(parse_Imp.call(parse_Or.call(parse_And.call(parse_Atom))),inp)
      end

      def parse(inp)
        make_parser(method(:parse_formula).curry.call(method(:parse_infix_atom),
          method(:parse_atom), []), inp)
      end
    end
  end
end

class String
  def to_formula
    FirstOrderLogicParser.parse(self)
  end
end
