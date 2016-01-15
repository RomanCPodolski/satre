require 'test_helper'

class LexerTest < Minitest::Test
  def test_matches
    assert Lexer.matches("12334", "1")
    assert Lexer.matches(")(*)(&)", "()")
    refute Lexer.matches(")(*)(&)", "0")
  end

  def test_space?
    assert Lexer.space?(" ")
    assert Lexer.space?("\t")
    assert Lexer.space?("\n")
    assert Lexer.space?("\r")
    refute Lexer.space?("a")
    refute Lexer.space?("1")
    refute Lexer.space?("\\")
    refute Lexer.space?("$#")
    refute Lexer.space?("()")
  end

  def test_punctuation?
    assert Lexer.punctuation?("()")
    assert Lexer.punctuation?("[]")
    assert Lexer.punctuation?("{}")
    refute Lexer.punctuation?("hans")
    refute Lexer.punctuation?("!@#")
    refute Lexer.punctuation?("129941")
  end

  def test_numberic?
    assert Lexer.numeric?("124")
    assert Lexer.numeric?("356")
    assert Lexer.numeric?("789")
    refute Lexer.numeric?("Hans")
    refute Lexer.numeric?("!@#")
  end

  def test_alpanumeric?
    assert Lexer.alpanumeric?("x_1'")
    assert Lexer.alpanumeric?("var9")
    assert Lexer.alpanumeric?("SIGMA_1")
    refute Lexer.alpanumeric?("x-1'")
    refute Lexer.alpanumeric?("(x23)")
    refute Lexer.alpanumeric?("$OMEGA")
  end

  def test_lexwhile
    skip 'do later'
  end

  def test_lex
    assert_equal ["2", "*", "(", "(", "var_1", "+", "x'", ")", "+", "11", ")"],
      Lexer.lex("2*((var_1 + x') + 11)")
    assert_equal ["if", "(", "*", "p1", "--", "==", "*", "p2", "++", ")", "then", "f", "(", ")", "else", "g", "(", ")"],
      Lexer.lex("if (*p1-- == *p2++) then f() else g()")
  end
end
