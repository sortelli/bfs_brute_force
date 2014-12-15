#!/usr/bin/env ruby

require 'bfs_brute_force'

# This is a very simple 'puzzle' to show how to use the bfs_brute_force gem
#
# Puzzle:
#
# Using the moves "Add 10" and "Add 1," find the shortest number
# of moves from a starting number to a final number.

class AdditionPuzzleState < BfsBruteForce::State
  def initialize(value, final)
    @value = value
    @final = final
  end

  # (see BfsBruteForce::State.solved?)
  def solved?
    @value == @final
  end

  # Call yield for every next state in your puzzle
  # This puzzle has two legal moves from every state: Add 10, and Add 1
  #
  # (see BfsBruteForce::State.next_states)
  def next_states(already_seen)
    # If there are no more available states to analyze,
    # {BfsBruteForce::Solver#solve} will throw a {BfsBruteForce::NoSolution}
    # exception.
    return if @value > @final

    # already_seen is a set passed to every call of next_states.
    # You can use this set to record which states you have previously
    # visited, from a shorter path, avoiding having to visit that
    # same state again.
    #
    # Set#add?(x) will return nil if x is already in the set
    if already_seen.add?(@value + 10)
      yield "Add 10", AdditionPuzzleState.new(@value + 10, @final)
    end

    if already_seen.add?(@value + 1)
      yield "Add 1", AdditionPuzzleState.new(@value + 1, @final)
    end
  end
end

# Find shortest path from 0 to 42
initial_state = AdditionPuzzleState.new 0, 42

solver = BfsBruteForce::Solver.new
moves  = solver.solve(initial_state).moves

moves.each_with_index do |move, index|
  puts "Move %d) %s" % [index + 1, move]
end

# Running this code will produce the following output:
#
# Move 1) Add 10
# Move 2) Add 10
# Move 3) Add 10
# Move 4) Add 10
# Move 5) Add 1
# Move 6) Add 1
