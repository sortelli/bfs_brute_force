require "minitest/autorun"

class TestBasic < Minitest::Unit::TestCase
  def test_module_exists
    assert BfsBruteForce
  end
end
