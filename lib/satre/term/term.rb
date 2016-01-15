class Term 
  attr_reader :function
  attr_reader :term_list

  def initialize(function, term_list=[])
    fail(ArgumentError, '...') unless function.is_a?(String)
    fail(ArgumentError, '...') unless term_list.is_a?(Array)
    @function = function.dup.freeze
    @term_list = term_list.dup.freeze
  end
end
