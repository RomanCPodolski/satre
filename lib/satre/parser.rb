require 'satre/lexer'
require 'satre/errors'

module Satre
  class Parser
    class << self
      def make_parser
        lambda do |pfn, inp|
          expr, rest = pfn.call(Lexer.lex(inp))
          fail(ParserError, "Unparsed input: #{rest}") unless rest == []
          return expr
        end
      end
    end
  end
end
