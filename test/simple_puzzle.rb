require "minitest/autorun"
require "bfs_brute_force"

class SimplePuzzleContext < BfsBruteForce::Context
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

  def next_moves(already_seen)
    return if @value > @final

    [1, 10, 100].each do |n|
      new_value = @value + n
      if already_seen.add?(new_value)
        yield "Add #{n}", SimplePuzzleContext.new(new_value, @final)
      end
    end
  end
end

class SlightlyHarderPuzzleContext < SimplePuzzleContext
  def next_moves(already_seen)
    [10, 100].each do |n|
      new_value = @value + n
      if already_seen.add?(new_value)
        yield "Add #{n}", SlightlyHarderPuzzleContext.new(new_value, @final)
      end
    end

    new_value = @value - 1
    if already_seen.add?(new_value)
      yield "Subtract 1", SlightlyHarderPuzzleContext.new(new_value, @final)
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
      solve_puzzle(SimplePuzzleContext, *args)
    end

    assert_raises(BfsBruteForce::NoSolution) do
      solve_puzzle(SimplePuzzleContext, 3, 2, [])
    end
  end

  def test_slightly_harder_puzzle
    [
      [0, 42,  ["Add 10"] * 5 + ["Subtract 1"] * 8],
      [2, 42,  ["Add 10"] * 4],
      [3, 427, ["Add 10"] * 3 + ["Add 100"] * 4 + ["Subtract 1"] * 6]
    ].each do |args|
      solve_puzzle(SlightlyHarderPuzzleContext, *args)
    end
  end

  def solve_puzzle(type, start, final, expected_moves)
    context = type.new(start, final)
    solver  = BfsBruteForce::Solver.new

    refute context.solved?, "Not already solved"

    state = solver.solve context, []

    assert_instance_of(BfsBruteForce::State, state)
    assert_instance_of(type, state.context)
    assert_instance_of(Array, state.moves)

    assert state.solved?
    assert state.context.solved?
    assert_equal state.context.value, final
    assert_equal expected_moves, state.moves
  end
end
