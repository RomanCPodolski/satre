require 'satre/lexer'

module Satre
  class Parser
    class << self
      def make_parser
        lambda do |pfn, inp|
          expr, rest = pfn.call(Lexer.lex(inp))
          return expr if rest == []
          fail(StandartError, 'Unparsed input')
        end
      end
    end
  end
end
