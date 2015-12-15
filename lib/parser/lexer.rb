require 'singleton'

# A parster for propositional statements
# and simple mathematical expressions
module Parser
  class Lexer

    private

    matches = lambda { |pattern, c| pattern.include? c }

    @space = matches.curry.call(" \t\n\r").dup.freeze
    @punctuation = matches.curry.call("()[]{}").dup.freeze
    @symbolic = matches.curry.call("~`!@#%$^&*-+=").dup.freeze
    @numeric = matches.curry.call("0123456789").dup.freeze
    @alpanumeric = matches.curry.call("abcdefghijklmnopqrstuvwxyz_'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789").dup.freeze

    def self.lexwhile(prop, inp)
      tokl = inp.split("").take_while { |c| prop.call(c) }.inject(:+)
      tokl = "" if tokl.nil?
      return tokl, inp[tokl.length..-1]
    end

    public

    def self.lex(inp)
      inp, rest = self.lexwhile(@space, inp)
      return [] if rest == "" || rest.nil?
      c = rest[0]
      cs = rest[1..-1]
      prop =  if @alpanumeric.call(c) then @alpanumeric
              elsif @symbolic.call(c) then @symbolic
              else proc { false } end
      toktl, rest = self.lexwhile prop, cs
      [c+toktl] + lex(rest)
    end

  end
end
