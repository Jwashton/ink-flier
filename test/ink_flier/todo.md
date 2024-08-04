# 2024-08-03
- Maybe extract another abstraction/module from Game: Round (aka a baby version of Stage/Phase engine)
  - Might be able to pull ROund and LockedIn fields into there
  - It would also need a copy of Players (or maybe just give it Players to be in charge of)
  - Might not work, but could be cool if it split off some of the helper functions (advanceRound etc) cleanly

# 2024-08-02
- Game.current_positions- Don't need this extra interface func afterall.
  - Just go back to original "get_current_game_state" get-everything function plan
  - And that'll return a map, which I'll pattern match on `%{current_positions: ...}` instead

# 2024-08-01
- I think I want to reverse Gamestate/server
  - InkFlier.Game = the struct module, then InkFlier.Game.Server (which I can `as: GameServer` when there's a conflict and just Server the rest of the time, which is nice I think)
  - It'll be Game.current_positions etc, instead of State.blabla which is a little harder to mentally parse I think

# 2024-07-31b
- Add types and doc
  - Skim through and find where missing
  - Wait till module/abstractions for car/board/game/etc are a little more locked in tho
- Put HouseRules back in, and use it for Game/Board playersInOrder function (with Enum.random)
- Track validator
  - Can't have a starting point already coliding with an obstacle
- GameTest, `describe "move"` section will probably be big enough to go in it's own seperate test file

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
