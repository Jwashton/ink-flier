# 2024-10-19
- LobbyGameController working good progress! Next todos:
  - no double-joins by same player
  - And leave game
  - And format the player list or make prettier css
  - And have lobby create and start game servers (not just start 1 manually in Application)
  - and finally send notification back to Lobby channel somehow to refresh it's player list
    - And also that those lobby games should point at gameservers (which will CHECK those updated player lists) instead of hardcoded :fakeGames or something like at present

- Ok, for next, just work on only single game page
  - Figure out connection to Lobby and stuff laer
  - Just make a Game page that has a creator, an id (in the url at least), and logged in player can click join or leave

- LobbyGameController- Confirm game is a currently running GameServer
- Maybe handle and return error msgs for some edge cases for GameServer (and Game. ) .join
  - same player tries to join? Just ignore, prob actually send msg "Already in game"

- @William
  - Just general question on the layout of the supervisor, the registry, the games... the lobby makes an id, just 1, 2, 3 inc. I use that instead of the creating player's name to name a game process, since a player might create multiple games

  - Messages between servers. Location. GenServer "engine" vs channels
    - Was going to test that game messages send notify to the lobby server that spawned them (when player joins game for example)
    - To test that was going to put it in engine layer
    - But then remembered I did the broadcasts for "game created" at the "top" channels layer
    - But lobby IS a genserver. Should it have handled it's own broadcasts in the genserver engine instead of the channel code?
    - This might answer itself after I try the 2nd way... (I did the channels broadcast for "lobby create game". Going to try the opposite and do genserver broadcast/send_info/etc for "game joined but lobby needs notify")

# 2024-10-18
- Maybe try to store game stuff in lobby like I'm doing
  - But after JoinGame is working, THEN move it to game genservers that notify lobby when joined or something?
    - Think more on this one. I can do it with channel broadcasts, but is it possible to do it more directly on engine code with the Lobby and Game servers?

# 2024-10-16
- LobbyServer test intermitent fails, by changing the api using the link William sent (@name... etc)
- Remove the onclick's in html and move them to being attached by javascript

# 2024-10-15
- [x] Get javascript to "draw games" function so it refreshes everyone's list on broadcast
- Add delete button to game rows
- Add which-track to game rows
- Then, start letting players JOIN games
  - Which will, at first, just show in lobby
  - But also have new page for game. Again, at first, just make a genserver or whatever (supervised by lobby server?), and just show who's joined and left.
- Refactor room_channel and user_socket.js a bit

- @William
  - javascript drawGames, having the html in the javascript is painful. Is there any way to move the html more out of the js. In a template file. or make the javascript use phoenix's function components or something?

  - By redrawing the entire list with drawGames, they can't get out of sync anymore which is good
    - BUT, now adding 2 new games in a row wipes out the "fade in cause this is new" animation on the first of the two new games
    - But where does this leave me? Append lets them get out of sync, but redraw-all only lets me look at the VERY last one drawn, no matter how recently the -2 and -3 ones were also drawn

  - Also, the drawGames (entire board refresh) has a lag when page first loads. Because js takes a while to load assumingly
    - Wheras before the controller did the first "drawGames" and fed it right to nice easy-to-use heex. Not stinky js writing huge html blocks

# 2024-10-13
- After pulling the navbar into layouts/app.html, login.html now shows itself twice
  - Think about the router/layout grouping. Login is kind of wanting it's own layout at this point
    - Since I also have that javascript error with the channel trying to connect to non-logged-in-pages
  - I need something like an "all my pages" css, and a "root with javascript", and "root without"...
  - Seems like a lot of non-dry copying of the root... stuff
  - It's fine for now, play with it later if I want

- @William
  - There are ways for the 2 Game Lists (on the html browser) to get out of sync
    - If page1 refreshes after restarting server, it (correctly) shows blank Game List
    - But the page2 DIDN'T refresh. It still has an old game list showing.
    - Now when page1 does the javascript ".prepend", it gets added to a (correct) blank Game List on page1
      - But on page2 the new game DOES get broadcasted, but gets prepended onto an old out-of-date incorrectly full Game List

    - One solution is to send out the entire current game list on broadcast instead of just the new game
      - But that seems wasteful, sending the entire list when most of the time only the new single game was needed
      - Worse, I have to have the javascript write a ton more html instead of just prepending 1 div

      - I could also try to broadcast an "empty the list" event when the server restarts. I'm not sure if there's a channel function/callback for that though
        - And it still seems like it would be possible for page1 and page2 to get out of sync

  - Are my stupid css class names close to right? The nav__login-link feels sketchy. The stupid "block independant from other blocks" is hard. Login should be it's own "component", but also it lives in the navbar...

# 2024-10-11
- Eventually make Lobby use a Registry (reread the Supervisor and Registry parts of the Elixir book)
- For now we'll just store the games with an id counter we'll keep, and map that to the pids

- @William
  - InkFlier.Lobby.Server vs InkFlier.Lobby. GenServer vs it's State. or InkFlier.LobbyServer. Or don't test the Lobby (state) at all and always go through genserver. Or vice versa. Or both. I'm supposed to split them up and keep the genserver thin I think, according to the Blackjack post. Altho the islands book doesn't do that, it mostly crams the GenServer AND the state for the genserver in the same module. The state is usually just getters and setters, but... sometimes more. Idl
    - And IF splitting it up, should one be sub to the other or both on the same level, name-wise. InkFlier.Lobby.State or InkFlier.Lobby.Server... etc
    - And which one should most of the testing be. Probably the functional one. But it's weird because it feels like the main thing I want and started with was the genserver, and I only made the "state" part of it as an after thought...

  - Lobbyserver test intermittent fail: mix test --seed 160764

  - Is there a better way to set both layouts at once? This seems unnatural, or like it isn't the way it would usually be done, but I'm not sure
      ``` in router
        plug :put_root_layout, html: {InkFlierWeb.LobbyLayouts, :root}
        plug :put_layout, html: {InkFlierWeb.LobbyLayouts, :app}
      ```
    - For example, inkFlierWeb (def controller) has JUST
        layouts: [html: InkFlierWeb.Layouts]
    - And router (top :browser level) has JUST
        plug :put_root_layout, html: {InkFlierWeb.Layouts, :root}
    - Why aren't they both in one or the other, together?
    - And why doesn't the one in def controller need Layouts, :app. It jUST says .Layouts

  - Can you help me figure out the firefox console error
      ```
      layout was forced before the page was fully loaded
      ```
    - How do I move function from home.html.heex script tag into user_socket.js
      - But still call it from `<a href onclick="sayHi('in html')">blablabla</a>`
      - I googled a lot and tried a ton of export stuff, but nothing I did seemed to let the html see function I declared in the .js file

# 2024-10-01
- @William
  - Update css:
    - Tailwind works on their page_controller, but not on my lobby_controller
    - But they're both using layout: false, or even if it's off they're both pointing at the layouts.ex file
    - I think I'm not understanding how layouts work. For example, layouts.ex has `embed_templates "layouts/*"`
      - Pointing at that layouts/ directory, just like page_html/ etc directorys. Same structure, great
      - But where is the explanation for app.html and root.html
      - I can't find the code for who calls that, or doc for if it's overrided, or whatever. How does phoenix get from InkFlierWeb.Layouts to "root.html" specifically. And how does THAT know that "inner content" is supposed to be "app.html"
    - And just in general, how do I turn on stinky tailwind. And how do I override app.html, or root.html, or both, for a specific page, but only when I want
    - If I check "inspect" in firefox, it is actually using those tailwind classes on the "/" route homepage, but completely ignores those tailwind classes on my "/lobby" etc

  - old css:
    - Right way to do css in, for example, this small login page?
      - Is tailwind off? It still works on their main "/" page
        - But doesn't work in this new clean page, even if I turn off render(conn, :new, layout: false) and remove the false part
    - If no tailwind is the way to go, is there a way to make a new empty starter css file and tell the controller to use that?
    - I'd kind of like to turn tailwind on for this just cause I'm a little more used to it. But it's fine if not

  - the create function in login_controller is ugly, is this normal?

  - I can't get the `<InkFlierWeb.LoginHTML.new user={@user} />` on lobby_html\home.html to align to right side

  - "sanitize user input"
    - In user_socket.ex I'm getting string data from either the url or javascript or whoever
    - Pretty sure I'm supposed to "clean" this before using it
      - I know ecto does that with whitelist stuff, but I'd rather not add a bunch of ecto changesets here unless that's what we're always supposed to do with user input
    - For now I'm just using it as a place to write userName (until there's login code or something later)
    - Is there a quicker way to clean input before using it to call functions like `Game.new(playerNameIGotFromJavascriptCall)`
      - I think the answer might be I AM always supposed to use the ecto changeset thing for form input
        - I think I actually remember the meerkats & other books doing this. Having a changeset even if there wasn't ecto save happening. Just for the form validation-error-messages but also for the clean input, now that I think about it

  - Tests for the controller/flow of the pages
    - For example the login and out, which page it redirects to with the "return_to" stuff I added...
    - There's a decent number of clicks involved in checking if everything works. Really feels like test
    - But am I not supposed to test the frontend so much?
    - But I think I DID see controller tests in hexdoc. Maybe I should reread and just do a few for the login stuff

  - mix format, or a plugin, or something? It seems awful but maybe good...
    - But it touches a million files
    - It would be nice to only touch recently changed files, or something
    - Also what if I disagree with a specific change and it keeps fighting me
    - Mostly I just wanted it for a tailwind plugin that supposedly exists to put the tailwind classes all in a standard order instead of just the random -whatever-order-I-typed-themin

# 2024-09-17
- Get rid of the direct {} = Reply.... calls, and use getters instead (to not assume the internals of Reply)

# 2024-09-13
- Update type and doc for Round. Possibly delete it and start from scratch just based on looking at the actual code
- For now, let's stop poking at round and play with Channels
- Later work more on all the Move edge cases (including winners, crashes, checkpoints, and the shortestPath algorithim for tiebreakers of all who crossed furthest checkpoint)

# 2024-09-10b
- After talking to William, probably *keep* Reply abstraction, don't flatten
  - Probably make it MORE of a black box, by giving it getters instead of straight getting the `{}` tuple out of it
    - eg. Reply.round & Reply.instruction
  - If I wanted at that point I could make the Instruction stuff a side effect (Agent/GenServer), but I probably shouldn't bother
  - The 3 modules work good, a nice seperation

- Probably go to this form (from below):
  - `Reply.add_instruction(reply, Instruction.notify_room/2... / notify_one/3)`
  - Then use something along these lines to fix the a->b->c->b thing that was annoying me with the bidirectional triangle
      ```
      defmodule InkFlier.Round.Reply do
      # ...

      # defdelegate player_locked_in(t, player), to: Instruction
      def player_locked_in(reply, player) do
        reply
        |> add_instruction(Instruction.player_locked_in)

        # |> add_instruction(&{:notify_player, player, {:ok, {:speed, Round.speed(&1, player)}}})
      end
      ```
      ```
        def player_locked_in(reply, player) do
          [
            {:notify_room, {:player_locked_in, player}},
            &{:notify_player, player, {:ok, {:speed, Round.speed(&1, player)}}}
          ]

          # reply
          # |> Reply.add_instruction({:notify_room, {:player_locked_in, player}})
          # |> Reply.add_instruction()
        end
      ```

  - Later if I want to I can make some sugar in JUST Reply to do it all without Round knowing both Reply and Instruction
    - With defdelegate or macros or something

- Then have fun with channels

# 2024-09-10
- First get rid of all calls to Reply.\*
  - Then start passing JUST instructions ([]) to Instruction, plus any specific info it needs pulled out of t/round from the old {round, reply} tuple (in a seperate extra param)

# 2024-08-31
- Later Change Round.move doc to not say "lots of possible replies" and instead list all the examples
  - Either there or more likely, in Instruction under each of those docs
    - And link to them in a list in Round.move's doc, maybe?
- Skip doing the big doc and type move FOR NOW tho, because after the channel stuff (`get better idea of api` below, and the callback module etc), the return type of these lists will change so these examples will look different
- Again, this module (Instruction) will prob be the place to build all that shape tho

# 2024-08-27
- [ ] Get better idea of the api/retuns (instruction list, etc). By starting from top level, channels. Which will prob spin up a GenServer Game module, which will then call down to most of the stuff in Round
  - And try to adapt existing Round each step of the way, making small alters to it's stuff, but if I can, resist the urge to scrap it and start from scratch (That's a good tool too, but let me practice the working within existing stuff side of the spectrum too)
  - Also the merge early and merge often, I can get to a tests-passing, non-breaking-other-stuff state of round, but then can pullrequest/merge that on. "This is a Round that starts and can make a normal move in. It has to be non-illegal, non-crashing, non-winning `normal` move, which are things I still want to add. But this is a nice stable point, I can save and merge/pull request this pretty freely

- For Round.Reply/Round/Round.Instruction:
```
with :ok <- check_legal_move(t, player, destination),
     :ok <- check_not_already_locked_in(t, player) do
  t
  |> maybe_crash(player, destination)
  |> lock_in(player)

# this part, 2 different ideas. Prob the 2nd one. Solves the "triangle heirchy problem. Just Round calls to Reply. BUT I still get the benifit of keeping the Instruction.notify_room(:soAndSoMoved...) stuff in a seperate file. Kind of the best of both worlds
  |> Reply.add_instruction(Instruction.notify_room/2... / notify_one/3)
  |> Reply.notify_room/2... / notify_one/3, but defdelegate to another module (Instruction) to still keep seperate)

  |> Reply.add_instruction({:notify_room, {:player_locked_in, player}})
  |> Reply.add_instruction(&{:notify_player, player, {:ok, {:speed, speed(&1, player)}}})

```

  - After extracting the Instruction functions, can move the Types too

- Extra reminder that Game.summary will handle the "original board state BEFORE starting this round", which Round currently has a field for (original_board) but wont need to handle. just the higher Game will handle that. Round is handleing the still-changeing-and-only-partially-locked-in-board

- Prob use callback for how to handle the instruction list returns. The tests can prob use a PID and process and assert_recieved
  - Question of how the real code will want that callback to look
  - Thus the starting from channels top-level above, and seeing what shape I want the returns to look like most helpfully
  - 2024-09-01: I'm not sure this will work. Any code here is gonna need a process/pid to catch the other stuff...

- For tiebreaker winners
  - Whose crossed most checkpoints
  - Tiebreaker there: pathfinder (AoC style) to next checkpoint!
- For crash, maybe respawn at last checkpoint
  - But maybe save that for houserules

# 2024-08-24
- Instruction abstraction
  - possible able to "extract module" away some of that `{:notify_player, player, {:speed, speed(&1, player)}}` wrapping
  - And clean it away from Round module etc

- Next Round.move crash test (multiple crashes = multiple notifications) and (all-but-1crashes = last guy is winner), etc

- Think about round_test file. Round itself isn't bad, but the tests might be getting a bit brittle or clunky or something
  - Is there a nicer way to handle checking the returned instruction LIST?
    - Scanning for is_member?
    - But will that lose order information I need to check?
  - Related: Do instructions need to be a list? Maybe they're room-notifications (THAT'S a list) and each player's notification (each one is a list, the order matters there) but the order DOESN'T matter for what order THOSE outers go out in
    - Send player b's notifications, then send room notifications, then send player a's... that's fine
      - Just as long as the notifications sent to each of those sub groups go in order

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

