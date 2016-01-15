module Satre
  class Lexer
    class << self
      def matches
        lambda { |pattern, str| str.split("").all? { |c| pattern.include? c } }
      end

      def matches(pattern, str)
        str.split("").all? { |c| pattern.include? c }
      end
      
      def space?(str)
        matches(" \t\n\r", str)
      end

      def punctuation?(str)
        matches("()[]{}", str)
      end

      def symbolic?(str)
        matches("~`!@#%$^&*-+<=>\\/|", str)
      end

      def numeric?(str)
        matches("0123456789", str)
      end

      def alpanumeric?(str)
        matches("abcdefghijklmnopqrstuvwxyz_'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789", str)
      end

      def refute(*)
        false
      end

      def lexwhile(prop, inp)
        tokl = inp.split("").take_while { |c| self.send(prop, c) }.inject(:+)
        tokl = "" if tokl.nil? 
        return tokl, inp[tokl.length..-1]
      end

      def lex(inp)
        inp, rest = self.lexwhile(:space?, inp)
        return [] if rest == "" || rest.nil?
        c = rest[0]
        cs = rest[1..-1]
        prop =  if self.alpanumeric?(c) then :alpanumeric?
                elsif self.symbolic?(c) then :symbolic?
                else :refute end
        toktl, rest = self.lexwhile(prop, cs)
        [c+toktl] + lex(rest)
      end
    end
  end
end
