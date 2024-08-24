# 2024-08-24
- Do one of the below refactorings or do the next Round.move crash test (multiple crashes = multiple notifications) and (all-but-1crashes = last guy is winner), etc
- Round.move
  - Looks like the only change is in one place at top of pipe. I can do it at top of move just after the with I think
  - Then rest of pipe is the same, can DRY the doubled pipe I think

- Instruction abstraction
  - possible able to "extract module" away some of that `{:notify_player, player, {:speed, speed(&1, player)}}` wrapping
  - And clean it away from Round module etc

# 2024-08-13
- Board is going to need to hold RaceTrack, not just take Racetrack.start
  - so it can delete racetrack.start and just take racetrack in new
  - Needs this to check collisions against (which is the entire point of racetrack module)

- Actually, Board.move can probably do all the logic for checking crash and adding to crash list if it happened?

# 2024-08-10
- I think I'll remember this, but whichever parent ends up handeling endOfRound->startOfNext will need the most upToDate board
  - Which will be in Round.board (which is WHY we return a final Round in the {round, instructions} even tho that round ended; we'll still need to retrieve that most upToDate board out of it)

- Prob add some doc explaining the different clauses in Round.Reply (And use `## Examples` for each, just cut and pasting their uses from Round
  - These two in their diff clauses, for example:
      ```
      |> Reply.add_instruction({:notify_room, {:player_locked_in, player}})
      |> Reply.add_instruction(&{:notify_player, player, {:speed, speed(&1, player)}})
      ```

- Round.player_position_notifications can be partially extracted to Board.
  - The return gives those coord&speed maps, and the round comprehension uses THOSE to wrap {:notify room...} around it

- In typedoc for Round.instruction, I might not really need this. Everything's self explanitory EXCEPT notify_member
  - If I can make the "member = player OR observer" concept obvious somewhere or somehow else (rename it, or link to doc somewhere else...), then I can prob delete this unnecessary'ish typedoc

# 2024-08-08
- Do the typedoc "hide all except explicitly included" thing
  - Or actually, let's manually list the ones to exclude (all the generated stuff, InkFlier.Mailer, etc)
- Take a look at [dialyxir](https://github.com/jeremyjh/dialyxir)

# 2024-08-04
- RaceTrack.Obstacle.wall_lines type, try @opaque. See if that hides it when inspecting the struct

# 2024-08-03
- Maybe extract another abstraction/module from Game: Round (aka a baby version of Stage/Phase engine)
  - Might be able to pull ROund and LockedIn fields into there
  - It would also need a copy of Players (or maybe just give it Players to be in charge of)
  - Might not work, but could be cool if it split off some of the helper functions (advanceRound etc) cleanly

# 2024-08-02
- Game.current_positions- Don't need this extra interface func afterall.
  - Just go back to original "get_current_game_state" get-everything function plan
  - And that'll return a map, which I'll pattern match on `%{current_positions: ...}` instead

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

# General
- Nice next reads list:
  - https://hexdocs.pm/phoenix/channels.html
  - https://pragprog.com/titles/cdc-elixir/learn-functional-programming-with-elixir/
