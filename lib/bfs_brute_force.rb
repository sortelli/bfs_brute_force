require "bfs_brute_force/version"
require "set"

module BfsBruteForce
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
      list = []
      @context.next_moves(@already_seen) do |next_move, next_context|
        list << State.new(next_context, @moves + [next_move], @already_seen)
      end
      list
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

      states = [[State.new(initial_context)]]

      loop do
        status << ("Checking for solutions that take %4d moves. %7d new contexts\n" % [
          states.length - 1,
          states.last.length
        ])

        states.last.each do |state|
          if state.solved?
            status << "\nSolved:\n\n"
            state.moves.each {|m| status << "  #{m}\n"}
            status << "\n#{state.context}\n"
            exit 0
          end
        end

        states.push(states.last.flat_map {|s| s.next_states})

        raise "There are no more states to analyze" if states.last.size == 0
      end
    end
  end
end
