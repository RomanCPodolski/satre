require 'satre/parser/lexer'
require 'satre/formula'
require 'satre/errors'

module Satre
  class Parser
    class << self
      def make_parser(parsing_function, input)
        expr, rest = parsing_function.call(Lexer.lex(input))
        fail(ParserError, "Unparsed input: #{rest}") unless rest == []
        return expr
      end

      def is_const_name(string)
        string.split('').all? { |c| Lexer.numeric?(c)  } || string.nil?
      end

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
    end
  end
end
