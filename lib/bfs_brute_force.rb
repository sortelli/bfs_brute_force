require "bfs_brute_force/version"
require "set"

module BfsBruteForce
  class NoSolution < StandardError
    def initialize(tries)
      super("No solution in #{tries} tries. There are no more states to analyze")
    end
  end

  class Context
    attr_reader :state, :moves

    def initialize(state, already_seen = Set.new, moves = [])
      @state        = state
      @already_seen = already_seen
      @moves        = moves
    end

    def solved?
      @state.solved?
    end

    def next_contexts
      @state.next_states(@already_seen) do |next_move, next_state|
        yield Context.new(next_state, @already_seen, @moves + [next_move])
      end
    end
  end

  class State
    def solved?
      raise NotImplementedError, "solved? is not implemented yet"
    end

    def next_states(already_seen)
      raise NotImplementedError, "next_states is not implemented yet"
    end
  end

  class Solver
    def solve(initial_state, status = $stdout)
      status << "Looking for solution for:\n#{initial_state}\n\n"

      initial_context = Context.new(initial_state)

      if initial_context.solved?
        status << "Good news, its already solved\n"
        return initial_context
      end

      tries    = 0
      contexts = [initial_context]

      until contexts.empty?
        status << ("Checking for solutions that take %4d moves ... " % [
          contexts.first.moves.size + 1
        ])

        new_contexts = []

        contexts.each do |current_context|
          current_context.next_contexts do |context|
            tries += 1

            if context.solved?
              status << "solved in #{tries} tries\n\nMoves:\n"
              context.moves.each {|m| status << "  #{m}\n"}
              status << "\nFinal state:\n #{context.state}\n"
              return context
            end

            new_contexts << context
          end
        end

        contexts = new_contexts
        status << ("none in %9d new states\n" % contexts.size)
      end

      raise NoSolution.new(tries)
    end
  end
end
