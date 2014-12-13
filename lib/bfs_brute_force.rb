require "bfs_brute_force/version"
require "set"

module BfsBruteForce
  class NoSolution < StandardError
    def initialize(tries)
      super("No solution in #{tries} tries. There are no more states to analyze")
    end
  end

  class State
    attr_reader :context, :moves

    def initialize(context, moves = [], already_seen = Set.new)
      @context      = context
      @moves        = moves
      @already_seen = already_seen
    end

    def solved?
      @context.solved?
    end

    def next_states
      @context.next_moves(@already_seen) do |next_move, next_context|
        yield State.new(next_context, @moves + [next_move], @already_seen)
      end
    end
  end

  class Context
    def solved?
      raise NotImplementedError, "solved? is not implemented yet"
    end

    def next_moves(already_seen)
      raise NotImplementedError, "next_moves is not implemented yet"
    end
  end

  class Solver
    def solve(initial_context, status = $stdout)
      status << "Looking for solution for:\n#{initial_context}\n\n"

      initial_state = State.new(initial_context)

      if initial_state.solved?
        status << "Good news, its already solved"
        return initial_state
      end

      tries  = 0
      states = [initial_state]

      until states.empty?
        status << ("Checking for solutions that take %4d moves ... " % [
          states.first.moves.size + 1
        ])

        new_states = []

        states.each do |current_state|
          current_state.next_states do |state|
            tries += 1

            if state.solved?
              status << "solved in #{tries} tries\n\nMoves:\n"
              state.moves.each {|m| status << "  #{m}\n"}
              status << "\nFinal context:\n #{state.context}\n"
              return state
            end

            new_states << state
          end
        end

        states = new_states
        status << "none in #{states.size} new contexts\n"
      end

      raise NoSolution.new(tries)
    end
  end
end
