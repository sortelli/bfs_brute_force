require_relative "test_helper"

class AlreadySolvedState < BfsBruteForce::State
  def solved?
    true
  end
end

class BrokenState < BfsBruteForce::State
end

class TestBasic < Minitest::Test
  def test_module_exists
    mod_key = :BfsBruteForce
    assert Kernel.const_defined?(mod_key), "Module #{mod_key} missing"

    mod = Kernel.const_get mod_key
    %w{Context State Solver}.each do |c|
      assert mod.const_defined?(c), "Class #{mod}::#{c} missing"
    end
  end

  def test_already_solved
    state  = AlreadySolvedState.new
    solver = BfsBruteForce::Solver.new

    assert_raises(NotImplementedError) {state.next_states(nil)}
    assert state.solved?

    solver.solve state
  end

  def test_broken
    state  = BrokenState.new
    solver = BfsBruteForce::Solver.new

    assert_raises(NotImplementedError) {state.next_states(nil)}
    assert_raises(NotImplementedError) {state.solved?}
    assert_raises(NotImplementedError) { solver.solve(state) }
  end
end
