require 'satre/formula/term/term'

module Satre
  class Function < Term
    def to_s
      "#{function}(#{term_list.map(&:to_s).join(',')})"
    end
  end
end
