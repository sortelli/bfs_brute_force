require "minitest/autorun"
require "bfs_brute_force"

class SimplePuzzleContext < BfsBruteForce::Context
  attr_reader :value

  def initialize(start, final)
    @value = start
    @final = final
  end

  def solved?
    @value == @final
  end

  def next_moves(already_seen)
    [1, 10, 100].each do |n|
      yield "Add #{n}", SimplePuzzleContext.new(@value + n, @final)
    end
  end
end

class TestSimplePuzzle < Minitest::Unit::TestCase
  def test_simple_puzzle
    simple_puzzle(0, 42, ["Add 1"] * 2 + ["Add 10"] * 4)
    simple_puzzle(2, 42, ["Add 10"] * 4)
    simple_puzzle(3, 427, ["Add 1"] * 4 + ["Add 10"] * 2 + ["Add 100"] * 4)
  end

  def simple_puzzle(start, final, expected_moves)
    context = SimplePuzzleContext.new(start, final)
    solver  = BfsBruteForce::Solver.new

    refute context.solved?

    state = solver.solve context, []

    assert_instance_of(BfsBruteForce::State, state)
    assert_instance_of(SimplePuzzleContext, state.context)
    assert_instance_of(Array, state.moves)

    assert state.solved?
    assert state.context.solved?
    assert_equal state.context.value, final
    assert_equal state.moves, expected_moves 
  end
end
