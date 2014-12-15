require "bfs_brute_force/version"
require "set"

# Top level module for this framework
module BfsBruteForce
  # Exception thrown by {Solver#solve}
  class NoSolution < StandardError
    # @param num_of_solutions_tried [Fixnum] number of solutions previously tried
    def initialize(num_of_solutions_tried)
      super("No solution in #{num_of_solutions_tried} tries. There are no more states to analyze")
    end
  end

  # Context object that contains a State and a list of moves required
  # to reach that State from the initial State.
  #
  # @!attribute state [r]
  #    @return [State] the current state
  #
  # @!attribute moves [r]
  #    @return [Array] the list of moves to this state from
  #      the initial state
  class Context
    attr_reader :state, :moves

    # @param state        [State]  current state
    # @param already_seen [Set]    set of states already processed
    # @param moves        [Array]  list of moves to get to this state
    def initialize(state, already_seen = Set.new, moves = [])
      @state        = state
      @already_seen = already_seen
      @moves        = moves
    end

    # Check if current state is a solution
    # @return [Boolean]
    def solved?
      @state.solved?
    end

    # Generate all contexts that can be reached from this current context
    # @return [void]
    # @yieldparam next_context [Context] next context
    def next_contexts
      @state.next_states(@already_seen) do |next_move, next_state|
        yield Context.new(next_state, @already_seen, @moves + [next_move])
      end
    end
  end

  # Single state in a puzzle. Represent your puzzle as
  # a subclass of {State}.
  #
  # @abstract Override {#next_states}, {#to_s} and {#solved?}
  class State
    # Your implementation should yield a (move,state) pair for every
    # state reachable by the current state.
    #
    # You should make use of the already_seen set to only yield
    # states that have not previously been yielded.
    #
    # @example Use already_seen to only yield states not already yielded
    #   def next_states(already_seen)
    #     next_value = @my_value + 100
    #
    #     # See {Set#add?}. Returns nil value is already in the Set.
    #     if already_seen.add?(next_value)
    #       yield "Add 100", MyState.new(next_value)
    #     end
    #   end
    #
    # @param already_seen [Set] Set of all already processed states
    #
    # @yield [move, state]
    # @yieldparam move  [#to_s] Text description of a state transition
    # @yieldparam state [State] New state, reachable from current state with
    #                           the provided move
    #
    # @raise [NotImplementedError] if you failed to provide your own implementation
    # @return [void]
    def next_states(already_seen)
      raise NotImplementedError, "next_states is not implemented yet"
    end

    # Returns true if current state is a solution to the puzzle.
    #
    # @raise [NotImplementedError] if you failed to provide your own implementation
    # @return [Boolean]
    def solved?
      raise NotImplementedError, "solved? is not implemented yet"
    end
  end

  # Lazy breadth first puzzle solver
  class Solver
    # Find a list of moves from the starting state of the puzzle to a solution state.
    #
    # @param initial_state [State] Initial state of your puzzle
    # @param status        [#<<]   IO object to receive status messages
    #
    # @raise [NoSolution] No solution is found
    # @return [Context] Solved Context object has the final {State} and list of moves
    def solve(initial_state, status = [])
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
