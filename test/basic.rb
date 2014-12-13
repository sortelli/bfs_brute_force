require "minitest/autorun"
require "bfs_brute_force"

class TestBasic < Minitest::Unit::TestCase
  def test_module_exists
    mod_key = :BfsBruteForce
    assert Kernel.const_defined?(mod_key), "Module #{mod_key} missing"

    mod = Kernel.const_get mod_key
    %w{State Context Solver}.each do |c|
      assert mod.const_defined?(c), "Class #{mod}::#{c} missing"
    end
  end
end
