require 'test_helper'

class AddTest < Minitest::Test

  def test_that_it_has_a_version_number
    refute_nil ::Satre::VERSION
  end

end