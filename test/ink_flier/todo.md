# 2024-07-31
- Don't hold entire RaceTrack struct in Game.ex state, since it's huge
  - What's the alternative though? An id lookup or something? But that would be to a DB which would be even slower
  - Maybe Game state is the right place to hold it then, even though it's so big and never changes?
  - Ask @William

- Also @William:
  - Best way to deal with multiple Todo.txt's across multiple branches? I really only want one source of truth (on Engine branch, say) but it's akward having to stash all changes, checkout engine, type todo notes, commit, check feature branch back out, unstash changes

- Extract start-and-place-in-pole-positions logic to Game.State and/or from there to Board

# 2024-07-30
- The full Game(or GameServer) interface
  - start
  - move
  - resign
  - give me everything
- GameServer Test notes
  ```
  {:ok, game_pid_1} = GameServer.start_link(players, track etc..., self())

  assert_broadcast...
  ```

# 2024-07-19
- RaceTrack.check_collision- refactor

# 2024-07-19
- line.ex
  - Note in intersect?/2 code
    - @William any test (or your math knowledge) to confirm or deny the note's suspicion about on_segment?/3

# 2024-07-12
- game_test.ex
  - Game.new should have 2 or 3 options for player starting placement
    - In given order by default
    - Or random
  - @William Any way to test *Random* in: Game.new(players, track, HouseRules.new(random_pole_position?: true)
    - This is now in Board.start(board, random_pole_position?); same question tho

# 2024-07-04
- Track module
  - func- crash?

  - Valid? check
    - inner & outer don't overlap eachother
    - ^ don't overlap themselves
    - ^ start and end coord are same

  - NOTEs
    - Each wall: points="50,150 50,200 200,200 200,100"...

- (genServer step?) All players lock in moves at once, instead of turns
  - (PhaseEngine, aka StateEngine from the Islands book)

# 2024-06-28
- Check collision between car and track
- Game/"context" module
  - Rules checks here
    - eg. use Car.legal_moves to confirm move is legal
  - Maybe genserver like the islands book, circle back to that
