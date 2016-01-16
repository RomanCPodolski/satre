require 'satre/parser/parser'

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
        if inp != [] && inp1 == opsym
          parser_ginfix(opsym, opupdate, opupdate.call(sof, e1), subparser, tl+inp1)
        else
          sof.call(e1, inp1)
        end
      end

      # parse a list of items and combine them in a left associated manner
      def parse_left_infix(opsym, opcon)
        parse_ginfix(opsym, ->(f,e1,e2) { opcon.call(f.call(e1,e2)) }, ->(x) { x } )
      end

      # parse a list of items and combine them in a right associated manner
      def parse_right_infix(opsym, opcon)
        parse_ginfix(opsym, ->(f,e1,e2) { f.call(opcon.call(e1,e2)) }, ->(x) { x } )
      end

      # parse a list of items and collect them in a list
      def parse_list(opensym)
        parse_ginfix(opsym, ->(f,e1,e2) { f.call(e1)+e2 }, ->(x) { x })
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
        return ast, rest if rest[1] == closing_character
        fail(ExpressionError, "Expected closing character '#{closing_character}'")
      end

      # absorbs the list of variables allowing the convention of
      # repeated quantifiers
      def parse_quant(inf, anf, vs, qcon, x, inp)
        fail(ArgumentError, 'Expected an formula at end of input') if inp == []
        head = inp.first
        rest = inp[1..-1]
        param = if head == '.' 
          parse_formula(ifn, afn, vs, rest)
        else
          parse_quant(ifn, afn, y+vs, qcon, y, rest)
        end
        papply( ->(fm) { qcon.call(x, fm) }, param  )
      end

      # ifn: restricted parser for infix atoms
      # afn: more general parser for arbitary atoms
      def parse_atomic_formula(ifn, afn, vs, inp)
        fail(ArgumentError, 'Expected an formula at end of input') if inp = []
        head = inp.first
        rest = inp[1..-1]
        case head 
        when "false" then return False.new, rest
        when "true" then return True.new, rest
        when "(" then parse_bracketed(parse_formula(ifn, afn, vs, inp), ")", rest)
        when "~" then papply(->(p) { Not.new(p) }, parse_atomic_formula(ifn, afn, vs, rest))
        when "forall" then parse_quant(ifn, afn, x+vs, ->(x,p) { Forall.new(x,p) }, x, rest)
        when "exists" then parse_quant(ifn, afn, x+vs, ->(x,p) { Exists.new(x,p) }, x, rest)
        else afn.call(vs, inp)
        end
      end

      # vs: set of bounds variables in the current scope
      # inp: current input 
      def parse_atomic_term(vs, inp)
        fail(ArgumentError, 'Term expected') if inp == []
        head = inp.first
        rest = inp[1..-1]
        if head == '('
          parse_bracketed(parse_term(vs), ")", rest)
        elsif head == '-'
          papply( ->(t) { Term.new("-", [t]) }, parse_atomic_term(vs, rest) )
        elsif Lexer.alphanumeric?(head) && rest[0] == '('
          rest = rest[1..-1]
          if rest[0] == ')' 
            papply( -> { Term.new(f, []) }, rest[1..-1]  )
          else
            papply(->(args) { Term.neq(f, args) }, parse_bracketed(parse_list(',', parse_term(vs)), ')', rest))
          end
        else
          a = if is_const_name(head) && !vs.include?(head) then Fun.new(head,[]) else Var.new(head) end
          return a, rest
        end
      end

      #
      def parse_formula(ifn, afn, vs, inp)
        parse_right_infix("<=>", ->(p,q) { Iff.new(p,q) },
          parse_right_infix("==>", ->(p,q) { Imp.new(p,q) },
            parse_right_infix("\\/", ->(p,q) { Or.new(p,q) },
              parse_right_infix("/\\", ->(p,q) { And.new(p,q) },
                parse_atomic_formula(ifn, afn, vs)))), inp)
      end

      # build up parsing of general terms via parsing of the various infix operations
      def parse_term(vs, inp)
        parse_right_infix("::", ->(e1,e2) { Fun.new('::', [e1, e2])},
          parse_right_infix("+", ->(e1,e2){ Fun.new('+', [e1, e2])},
            parse_left_infix(  "-", ->(e1,e2) { Fun.new('-', [e1, e2])}, 
              parse_right_infix( '*', ->(e1,e2) { Fun.new('*', [e1, e2])}, 
                parse_left_infix('/', ->(e1,e2) { Fun.new('/', [e1,e2])},
                  parse_left_infix('^', ->(e1,e2) {Fun.new('^', [e1,e2])},
                    parse_atomic_term(vs)))))),inp)
      end

      def is_const_name(string)
        string.split('').all? { |c| Lexer.numeric?(c)  } || string.nil?
      end
      
      def parse_infix_atom(vs, inp)
        tm, rest = parse_term(vs, inp)
        if ["=", '<', '<=', '>', ">="].include?(rest[1])
          papply( ->(tm_) { Atom.new(R.new(rest[0], [tm,tm_]))  }, parse_term(vs, rest[1..-1]))
        else fail "" # Excepion erfinden
        end
      end

      def parse_atom(vs, inp)
        parse_infix_atom(vs inp)
        rescue Exception => e
          head = inp.first
          rest = inp[1..-1]
          if rest[0] == '('
            rest = rest[1..-1]
            if rest[0] == ')' 
              return Atom.new(R.new(p, [])), rest[1..-1]
            else
              papply( ->(args) { Atom.new(R.new(p,args))}, parse_bracketed(parse_list(',', parse_term(vs)), ')', rest))
            end
          else
            return Atom.new(R.new(p, [])), rest if head != '('
            fail(ParserError, 'Parse Atom')
          end
      end

      def parse(inp)
        make_parser.curry.call(parse_formula(parse_infix_atom, parse_atom), []).call(inp)
      end
    end
  end
end

class String
  def to_fol
    FirstOrderLogicParser.parse(self)
  end
end
