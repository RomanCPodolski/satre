module Satre
  class Lexer
    class << self
      def matches
        lambda { |pattern, str| str.split("").all? { |c| pattern.include? c } }
      end

      def space?
        self.matches.curry.call(" \t\n\r").dup.freeze
      end

      def punctuation?
        self.matches.curry.call("()[]{}").dup.freeze
      end

      def symbolic?
        self.matches.curry.call("~`!@#%$^&*-+<=>\\/|").dup.freeze
      end

      def numeric?
        self.matches.curry.call("0123456789").dup.freeze
      end

      def alpanumeric?
        self.matches.curry.call("abcdefghijklmnopqrstuvwxyz_'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789").dup.freeze
      end

      def lexwhile(prop, inp)
        tokl = inp.split("").take_while { |c| prop.call(c) }.inject(:+)
        tokl = "" if tokl.nil?
        return tokl, inp[tokl.length..-1]
      end

      def lex(inp)
        inp, rest = self.lexwhile(self.space?, inp)
        return [] if rest == "" || rest.nil?
        c = rest[0]
        cs = rest[1..-1]
        prop =  if self.alpanumeric?.call(c) then self.alpanumeric?
                elsif self.symbolic?.call(c) then self.symbolic?
                else proc { false } end
        toktl, rest = self.lexwhile prop, cs
        [c+toktl] + lex(rest)
      end
    end
  end
end
