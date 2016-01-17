require 'satre/formula/term/term'

module Satre
  class Function < Term
    attr_reader :function
    attr_reader :term_list

    def initialize(function, term_list=[])
      #fail(ArgumentError, '...') unless function.is_a?(String)
      #fail(ArgumentError, '...') unless term_list.is_a?(Array)
      @function = function.dup.freeze
      @term_list = term_list.dup.freeze
    end

    # A term $f(x_1,...,x_n)$ is well-formed if
    #   (a) Each term $x_1,...,x_n$ is well formed
    #   (b) There is a pair (a, m) in signature sig where s = f and n = m
    #
    # sig is a hash containing the signature domain
    def wellformed?(sig)
      term_list.all? { |x| x.wellformed?(sig) } && sig[function.to_sym] == term_list.length
    end

    #   | Fn(f,args) -> func f (map (termval m v), args);;
    def validate(func, pred, valudation)
      func.call(f, term_list.map { |t| t.validate(func, pred, valudation) })
    end

    def to_s
      "#{function}(#{term_list.map(&:to_s).join(',')})"
    end
  end
end
