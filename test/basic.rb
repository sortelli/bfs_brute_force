require "minitest/autorun"
require "bfs_brute_force"

class AlreadySolvedContext < BfsBruteForce::Context
  def solved?
    true
  end
end

class TestBasic < Minitest::Unit::TestCase
  def test_module_exists
    mod_key = :BfsBruteForce
    assert Kernel.const_defined?(mod_key), "Module #{mod_key} missing"

    mod = Kernel.const_get mod_key
    %w{State Context Solver}.each do |c|
      assert mod.const_defined?(c), "Class #{mod}::#{c} missing"
    end
  end

  def test_already_solved

    context = AlreadySolvedContext.new
    solver  = BfsBruteForce::Solver.new

    assert_raises(NotImplementedError) {context.next_moves(nil)}
    assert context.solved?

    solver.solve context, []
  end
end
