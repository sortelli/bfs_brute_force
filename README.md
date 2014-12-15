# BfsBruteForce

[![Gem Version](https://badge.fury.io/rb/bfs_brute_force.png)](http://badge.fury.io/rb/bfs_brute_force)

Lazy breadth first brute force search for solutions to puzzles.

This ruby gem provides an API for representing the initial state
and allowed next states of a puzzle, reachable through user defined
moves. The framework also provides a simple solver which will lazily
evaluate all the states in a breadth first manner to find a solution
state, returning the list of moves required to transition from the
initial state to solution state.

## Installation

Add this line to your application's Gemfile:

    gem 'bfs_brute_force'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install bfs_brute_force

## Usage

Your puzzle must be represented by a subclass of ```BfsBruteForce::State```.
Each instance of your State subclass must:

1. Store the current state of the puzzle (instance attributes)
2. Determine if the state is a win condition of the puzzle (```solved?```)
3. Provide a generator for reaching all possible next states (```next_states```)

### Simple Addition Example Puzzle

Using the moves "Add 10" and "Add 1," find the shortest number
of moves from a starting number to a final number.

To use ```BfsBruteForce``` you will create your
```BfsBruteForce::State``` subclass as follows:

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

Each instance of ```AdditionPuzzleState``` is immutable. The
```next_states``` method takes a single argument, which is a ```Set```
instance, that can be optionally used by your implementation to
record states that have already been evaluated, as any previously
evaluated state is already known to not be a solution.

Inside of ```next_states``` you should yield two arguments for every
valid next state of the puzzle:

1. A user defined string, naming the move required to get to the next state
2. The next state, as a new instance of your ```BfsBruteForce::State``` class.

Now that you have your ```BfsBruteForce::State``` class, you can
initialize it with your starting puzzle state, and pass it to
```BfsBruteForce::Solver#solve```, which will return an object that
has a ```moves``` method, which returns an array of the move
names yielded by your ```next_states``` method:

    # Find shortest path from 0 to 42
    initial_state = AdditionPuzzleState.new 0, 42

    solver = BfsBruteForce::Solver.new
    moves  = solver.solve(initial_state).moves

    moves.each_with_index do |move, index|
      puts "Move %d) %s" % [index + 1, move]
    end

Running this code will produce the following output:

    Move 1) Add 10
    Move 2) Add 10
    Move 3) Add 10
    Move 4) Add 10
    Move 5) Add 1
    Move 6) Add 1

See [example/simple_addition.rb](example/simple_addition.rb) for the full solution.

### Two Knights Example Puzzle

Swap the white and black knights, using standard chess moves.
This is the "two knights" puzzle from an old video game, The 11th Hour.

Initial board layout:

      +----+
    4 | BK |
      +----+----+----+----+
    3 |    |    |    | WK |
      +----+----+----+----+
    2 | BK | WK |    |
      +----+----+----+
    1 |    |    |
      +----+----+
        a    b    c    d

    BK = Black Knight
    WK = White Knight

See [example/two_knights.rb](example/two_knights.rb) for a working solution.

### Four Bishops Example Puzzle

Swap black and white bishops, following standard chess movement
rules, except that bishops may not move to a square that would allow
them to be captured by an enemy bishop (they may not put themselves
in "check").

This is the "four bishops" puzzle from an old video game, The 7th Guest.

Initial Board layout:

      +----+----+----+----+----+
    4 | BB |    |    |    | WB |
      +----+----+----+----+----+
    3 | BB |    |    |    | WB |
      +----+----+----+----+----+
    2 | BB |    |    |    | WB |
      +----+----+----+----+----+
    1 | BB |    |    |    | WB |
      +----+----+----+----+----+
        a    b    c    d    e

    BB = Black Bishop
    WB = White Bishop

See [example/four_bishops.rb](example/four_bishops.rb) for a working solution.

## License

Copyright (c) 2014 Joe Sortelli

MIT License

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
