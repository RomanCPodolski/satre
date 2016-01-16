require 'satre/lexer'
require 'satre/errors'

module Satre
  class Parser
    class << self
      def make_parser(parsing_function, input)
        expr, rest = parsing_function.call(Lexer.lex(input))
        fail(ParserError, "Unparsed input: #{rest}") unless rest == []
        return expr
      end
    end
  end
end
