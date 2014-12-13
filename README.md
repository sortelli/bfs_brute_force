# BfsBruteForce

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

Your puzzle must be represented by a subclass of ```BfsBruteForce::Context```.
Each instance of your Context subclass must:

1. Store the current state of the puzzle (instance attributes)
2. Determine if the state is a win condition of the puzzle (```solved?```)
3. Provide a generator for reaching all possible next states (```next_moves```)

### Example Puzzle

Imagine a simple puzzle where you are given a starting number, an
ending number, and you can only perform one of three addition
operations (adding one, ten, or one hundred).

To use ```BfsBruteForce``` you will create your
```BfsBruteForce::Context``` subclass as follows:
    require 'bfs_brute_force'

    class AdditionPuzzleContext < BfsBruteForce::Context
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
            yield "Add #{n}", AdditionPuzzleContext.new(new_value, @final)
          end
        end
      end
    end

Each instance of ```AdditionPuzzleContext``` is immutable. The
```next_moves``` method takes a single argument, which is a ```Set```
instance, that can be optionally used by your implementation to
record states that have already been evaluated, as any previously
evaluated state is already known to not be a solution.

Inside of ```next_moves``` you should yield two arguments for every
valid next state of the puzzle:

1. A string, naming the move required to get to the next state
2. The next state, as a new instance of your ```BfsBruteForce::Context``` class.

Now that you have your ```BfsBruteForce::Context``` class, you can
initialize it with your starting puzzle state, and pass it to
```BfsBruteForce::Solver#solve```, which will return an object that
has a ```moves``` method, which returns an array of the move
names yielded by your ```next_moves``` method:

    solver   = BfsBruteForce::Solver.new
    solution = solver.solve(AdditionPuzzleContext.new(0, 42))

    solution.moves.each_with_index do |move, index|
      puts "Move %02d) %s" % [index + 1, move]
    end

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
