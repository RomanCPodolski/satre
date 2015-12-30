require 'satre/expression'

module Satre
  class Var < Expression
    def initialize(s)
      fail(ArgumentError, 's must be a string') unless s.is_a?(String)
      super "Var \"#{s}\""
    end

    def eval(_valudation)
      fail 'not implemented'
    end
  end
end
