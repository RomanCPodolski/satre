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
        puts "parse_ginfix #{opsym}, #{opupdate}, #{sof} #{subparser}, #{inp}"
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
        puts "parse_left_infix #{opsym} #{opcon}"
        opupdate = ->(f, e1 ,e2) {opcon.call(f.call(e1), e2) }
        sof = ->(x) { x }
        method(:parse_ginfix).curry.call(opsym, opupdate, sof)
      end

      # parse a list of items and combine them in a right associated manner
      # returns a lambda
      def parse_right_infix(opsym, opcon)
        puts "parse_right_infix #{opsym} #{opcon}"
        opupdate = ->(f,e1,e2) { f.call(opcon.call(e1,e2)) }
        sof = ->(x) { x }
        method(:parse_ginfix).curry.call(opsym, opupdate, sof)
      end

      # parse a list of items and collect them in a list
      def parse_list(opensym)
        puts 'parse_list'
        opupdate = ->(f,e1,e2) { f.call(e1)+e2 }
        sof = ->(x) { x }
        method(:parse_ginfix).curry.call(opsym, opupdate, sof)
      end

      # Applies a function to the first element of a pair.
      # The idea being to modify the returned abstract syntax tree while leaving
      # the `unparsed input` alone
      def papply(f, ast, rest)
        puts 'papply'
        return f.call(ast), rest
      end

      # Checks if the head of a list (typically the list of unparsed input)
      # is some particular item, but also first checks that the list is nonempty
      # before looking at its head
      def nextin(inp, tok)
        puts 'nextin'
        inp != [] && inp.first == tok
      end

      # Deals with the common situation of syntastic items enclosed in brackets
      # It simply calls the subparser and  then checks and eliminates
      # the closing bracket. In principle, the therminating character can be anything,
      # so this function could equally be used for other purposes.
      def parse_bracketed(subparser, closing_character, inp)
        puts 'parse_bracketed'
        ast, rest = subparser.call(inp)
        return ast, rest if rest[1] == closing_character
        fail(ExpressionError, "Expected closing character '#{closing_character}'")
      end

      # absorbs the list of variables allowing the convention of
      # repeated quantifiers
      def parse_quant(ifn, afn, vs, qcon, x, inp)
        puts 'parse_quant'
        fail(ArgumentError, 'Body of quantified term expected') if inp == []
        head = inp.first
        rest = inp[1..-1]
        ast, rest = if head == '.' then parse_formula(ifn, afn, vs, rest) else parse_quant(ifn, afn, vs.push(head), qcon, head, rest) end
        papply( ->(fm) { qcon.call(x,fm) }, ast, rest )
      end

      # ifn: restricted parser for infix atoms
      # afn: more general parser for arbitary atoms
      def parse_atomic_formula(ifn, afn, vs, inp)
        puts "parse_atomic_formula #{vs} #{inp}"
        fail(ArgumentError, 'Expected an formula at end of input') if inp == []
        head = inp.first
        rest = inp[1..-1]
        case head 
        when "false" then return False.new, rest
        when "true" then return True.new, rest
        when "(" 
          puts 'brackets'
          parse_bracketed(parse_formula(ifn, afn, vs, inp), ")", rest)
        when "~" 
          puts 'not'
          papply(->(p) { Not.new(p) }, parse_atomic_formula(ifn, afn, vs, rest))
        when "forall" 
          puts 'forall'
          parse_quant(ifn, afn, vs.push(rest[0]), ->(x,p) { Forall.new(x,p) }, rest[0], rest[1..-1])
        when "exists" 
          puts 'exists'
          parse_quant(ifn, afn, vs.push(rest[0]), ->(x,p) { Exists.new(x,p) }, rest[0], rest[1..-1])
        else
          puts 'atomic value'
          afn.call(vs, inp)
        end
      end

      # vs: set of bounds variables in the current scope
      # inp: current input 
      def parse_atomic_term(vs, inp)
        puts "parse_atomic_term #{vs} #{inp}"
        fail(ArgumentError, 'Term expected') if inp == []
        head = inp.first
        rest = inp[1..-1]
        puts "#{head} #{rest}"
        puts head == '('
        puts head == '-'
        puts Lexer.alpanumeric?(head)
        puts rest[0] == "("
        puts Lexer.alpanumeric?(head) && rest[0] == '('
        if head == '(' then parse_bracketed(parse_term(vs), ")", rest)
        elsif head == '-' then papply( ->(t) { Function.new("-", [t])}, parse_atomic_term(vs, rest) )
        elsif Lexer.alpanumeric?(head) && rest[0] == '('
          rest = rest[1..-1]
          if rest[0] == ')' 
            papply( -> { Function.new(f, []) }, rest[1..-1]  )
          else
            papply(->(args) { Function.neq(f, args) }, parse_bracketed(parse_list(',', parse_term(vs)), ')', rest))
          end
        else
          a = if is_const_name(head) && !vs.include?(head) then Function.new(head,[]) else Variable.new(head) end
          return a, rest
        end
      end

      # build up parsing of general terms via parsing of the various infix operations
      def parse_term(vs, inp)
        puts "parse_term #{vs} #{inp}"
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
        puts 'is_const_name'
        string.split('').all? { |c| Lexer.numeric?(c)  } || string.nil?
      end
      
      def parse_infix_atom(vs, inp)
        puts "parse_infix_atom #{vs} #{inp}"
        tm, rest = parse_term(vs, inp)
        puts "#{tm}, #{rest}"
        if rest != [] && ["=", '<', '<=', '>', ">="].include?(rest.first)
          ast, ost = parse_term(vs, rest[1..-1])
          papply( ->(tm_) {Atom.new(Relation.new(rest[0], [tm, tm_]))  }, ast, ost )
        else fail ParserError, 'calculated' # Excepion erfinden
        end
      end

      def parse_atom(vs, inp)
        puts 'parse_atom'
        parse_infix_atom(vs, inp)
        rescue ParserError
          head = inp.first
          rest = inp[1..-1]
          if rest[0] == '('
            rest = rest[1..-1]
            if rest[0] == ')' 
              return Atom.new(Relation.new(head, [])), rest[1..-1]
            else
              papply( ->(args) { Atom.new(Relation.new(head,args))}, parse_bracketed(parse_list(',', parse_term(vs)), ')', rest))
            end
          else
            return Atom.new(Relation.new(head, [])), rest if head != '('
            fail(ParserError, 'Parse Atom')
          end
      end

      def parse_formula(ifn, afn, vs, inp)
        puts 'parse formula'
        parse_Iff = parse_right_infix("<=>", ->(p,q) { Iff.new(p,q)})
        parse_Imp = parse_right_infix("==>", ->(p,q) { Imp.new(p,q)})
        parse_Or = parse_right_infix("\\/", ->(p,q) { Or.new(p,q)})
        parse_And = parse_right_infix("/\\", ->(p,q) { And.new(p,q)})
        parse_Atom = method(:parse_atomic_formula).curry.call(ifn, afn, vs)
        parse_Iff.call(parse_Imp.call(parse_Or.call(parse_And.call(parse_Atom))),inp)
      end

      def parse(inp)
        puts 'parse'
        make_parser(method(:parse_formula).curry.call(method(:parse_infix_atom),
          method(:parse_atom), []), inp)
      end
    end
  end
end

class String
  def to_fol
    FirstOrderLogicParser.parse(self)
  end
end
