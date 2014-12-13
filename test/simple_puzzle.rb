require "minitest/autorun"
require "bfs_brute_force"

class SimplePuzzleState < BfsBruteForce::State
  attr_reader :value

  def initialize(start, final)
    @start = start
    @value = start
    @final = final
  end

  def solved?
    @value == @final
  end

  def to_s
    "<#{self.class} puzzle from #{@start} to #{@final}>"
  end

  def next_states(already_seen)
    return if @value > @final

    [1, 10, 100].each do |n|
      new_value = @value + n
      if already_seen.add?(new_value)
        yield "Add #{n}", SimplePuzzleState.new(new_value, @final)
      end
    end
  end
end

class SlightlyHarderPuzzleState < SimplePuzzleState
  def next_states(already_seen)
    [10, 100].each do |n|
      new_value = @value + n
      if already_seen.add?(new_value)
        yield "Add #{n}", SlightlyHarderPuzzleState.new(new_value, @final)
      end
    end

    new_value = @value - 1
    if already_seen.add?(new_value)
      yield "Subtract 1", SlightlyHarderPuzzleState.new(new_value, @final)
    end
  end
end

class TestSimplePuzzle < Minitest::Unit::TestCase
  def test_simple_puzzle
    [
      [0, 42,  ["Add 1"]  * 2 + ["Add 10"] * 4],
      [2, 42,  ["Add 10"] * 4],
      [3, 427, ["Add 1"]  * 4 + ["Add 10"] * 2 + ["Add 100"] * 4]
    ].each do |args|
      solve_puzzle(SimplePuzzleState, *args)
    end

    assert_raises(BfsBruteForce::NoSolution) do
      solve_puzzle(SimplePuzzleState, 3, 2, [])
    end
  end

  def test_slightly_harder_puzzle
    [
      [0, 42,  ["Add 10"] * 5 + ["Subtract 1"] * 8],
      [2, 42,  ["Add 10"] * 4],
      [3, 427, ["Add 10"] * 3 + ["Add 100"] * 4 + ["Subtract 1"] * 6]
    ].each do |args|
      solve_puzzle(SlightlyHarderPuzzleState, *args)
    end
  end

  def solve_puzzle(type, start, final, expected_moves)
    state  = type.new(start, final)
    solver = BfsBruteForce::Solver.new

    refute state.solved?, "Not already solved"

    context = solver.solve state

    assert_instance_of(BfsBruteForce::Context, context)
    assert_instance_of(type, context.state)
    assert_instance_of(Array, context.moves)

    assert context.solved?
    assert context.state.solved?
    assert_equal context.state.value, final
    assert_equal expected_moves, context.moves
  end
end
