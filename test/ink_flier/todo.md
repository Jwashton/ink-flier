# 2024-10-29
- Supervisor of supervisor's (GameSystem or something for name) is fine. Something to start GameSupervisor and GameStore (mini version of LobbyServer's current cache simple list keeping of via-names
  - And LobbyServer retired as a process, but still have a Lobby with some useful helper functions that the channel can call, like loop through and build the maps to pass down or whatever
  - The one_for_rest or w/e strategy will be interesting
    - But basically GameStore (GameNameStore or w/e), on startup, instead of starting with an empty lists, asks whereis_children on GameSupervisor. Which WILL usually BE an empty list. But, if GameStore is restarting itself from a crash, can now rebuild it's list
      - GameServer's will need to store their own name, so the whereis (list of pids) can ask each one their name
      - Prob also store it's start time, so the whereis/GameStore can sort by that
- Lobby (or maybe the toplevel GameSystem supervisor) acts like a context, that has a start_game, and HE calls out to GameStore and GameSupervisor (and a db call and w/e else)
- `{id, opts} = Keyword.pop!(opts, :id)`
  - For requireing certain keywords and wanting prettier errors, maybe use With statement for those

# 2024-10-28
- [ ] The fun LobbyServer and GameServer sending updates between themselves part!
  - When finished, will be: Cross genserver messages, used for javascript live screen updates for events cause on OTHER pages =)

  - https://hexdocs.pm/phoenix_pubsub/Phoenix.PubSub.html
  - https://hexdocs.pm/ex_unit/1.12.3/ExUnit.Assertions.html#assert_receive/3
    - (or assert_received)
  - Just subscribe to the PubSub topic in my testcode.
- Depending on q below, remove the `name \\ @name` from GameSupervisor, who doesn't need it if we're starting everything through LobbyServer like we should?

# 2024-10-26
- @William
  - Is the layering a problem? LobbyServer (Lobby state) -> GameSupervisor -> GameServer(Game state)
    - If I go very slow (Like new route) it works fine. It seems like a lot of moving parts and easy to screw up.
    - If it's right that's great and fine, I'll get used to it. But worried I'm making it more complicated than I'm supposed to and easy to break
  - A LITTLE confused about when I need "seperate per-test process" and when, even in tests, I can get away with using the global one
      ```lobby_server_test.exs
      setup do
        # NOTE Aparently I don't need unique GameSupervisor for tests to not collide? I can just use
        # the Application-started one

        # start_supervised!({GameSupervisor, name: @game_starter})
        # start_supervised!({LobbyServer, name: @lobby, game_supervisor: @game_starter})
        start_supervised!({LobbyServer, name: @lobby})
      end
      ```
    - It KIND of makes sense. Lobby process restarting between tests stops "which games are and aren't started" bleeding into results of other tests
    - Except they're all linked to GameSupervisor. Doesn't HE need to be shut down between tests
      - Except they're ALL calling start_link. So maybe just killing one of them, particularly the Lobby one that called at the top (Altho LOBBY didn't call GameSupervisor.startlink. Application did that. But, Lobby calls GameSupervisor.startGame, which does Supervisor.startChild, and the GameServer func THAT calls is a start_link... which links not to GameSupervisor who's function called Supervisor.startChild, but instead to Lobby, who called GameSupervisor.startGame which delegates to Supervisor.startChild?

    - Depending on answer, should I remove the `name \\ @name` from GameSupervisor, who doesn't need it if we're starting everything through LobbyServer like we should?
  - As of lobby_server.ex getting `@topic "room:lobby"`, that string is getting repeated in a lot of places now.
    - Here, the connecting .js, and the socket "router" & channel controller: user_socket.ex and room_channel.ex
    - Should/can I dry this at all some central place?

# 2024-10-24b
-Just look at web page and see what next small needed thing is
Try not to get pulled into theory so much

Just look at what's not right about lobby page
I need a list of game processes, nothing else super special
And i can get that!

They're manually started right now but i can get that list and get useful info from games

-Then i can right away play with lobby-<>game process notifies i was excited about

-Or look at what's missing in current game server
(Track #, at the very least)
--can use that to add what gameserver needs

-or i can work on create game
--which is where i guy overcomplicated and stuck currently
---so ignore it and do one if the other two, or keep eye on web page and try to only small add what i need

- Oof. Ok, new branch from main (supervised games). Let's try this again, smaller piece at a time. Keep web page working each step
  - compare to prev branch and pull in a few good pieces, Like the dynamicsupervisor
    - And GameServer can take multiple optional opts (Creator, Track #, etc) (default to nill in the state). Maybe only id required
      - Use keyword for those when they come in from params, maps the rest of the time

---

- maybe @William
Maybe instead of a) deleting everything from scratch
Or b) working inside big mess

- **keep mess but make new modules**
Name is hard but whatever
Then slowly switch over one func at a time

---

And remember try to do smaller slices. Just spawn games with game supervisor?
In baby level tests but can it go higher?
I have to decide if lobby needs to stay a genserver or exist at all

For now let's try just using gamesupervisor
To spawn and list and retrieve games?

Try it without lobby at all

Then once that's working maybe add lobby back in

Or maybe keep Libby but just def delegate everything
But later I can make it a cache if I want?



# 2024-10-24
- Let's delete LobbyServer/test and Lobby/test (mostly) and start from scratch.
  - Start with field :games List (instead of map)
    - (can mapset them and sort them by create date or something later)
    - Tempting to not track the children in a seperate list, but I think yes for now. Don't depend on whereis_children or whatever
  - Test that LobbyServer also starts GameSupervisor
  - Rebuild which functions I need by staring at the Webpage :)

# 2024-10-23
- Lobby sees game joins/leaves
  - All the awesome genserver stuff did with william
  - (Remember GameServer can just call regular client api functions in LobbyServer (like "Player added" or something)
    - (So don't need a handle-info/send() or anything there)

# 2024-10-22
- lobby_game_html: use:
    <input type="hidden" id="findHidden" value={@game_id}>
  instead of
    <template id="app"
        data-game-id = {@game_id}
    ></template>

- shared_code.js (instead of in app.js)
  - And this to do the import:
      import { sanitize } from "./app.mjs"

- Switch from +integer for GameId (made by lobby) to this
    ```
    token = :crypto.strong_rand_bytes(32)
    Base.url_encode64(token, padding: false)
    ```
- Finish making bang and non-bang version of remove_player, then use that in gameserver, then use THAT in channel to only do a broadcast on :ok and do nothing on :error, no such player to remove

# 2024-10-20
- @William
  - New .js file for each channel-connected page?
    - Is it ok that the build.mjs entryPoints file will start to get kind of long?
  - One channel per new web page is right? Not supposed to keep the socket between different pages or anything?
  - I need to pass value to .js before connecting to channel, or at all
    - For example, game channel needs to connect with game:123 where 123 = game's id
      - (Since there's only one game controller/html for ALL games. They get that gameId passed and change based on that)
      - So there's only game_socket.js
      - So it needs the channel to know that gameId to only get msgs for the right game
    - I found SOME online post that said:
        ```game.html.heex
        <template id="app"
                  data-game-id = {@game_id}
        ></template>
        ```
        ```game_socket.js
        const gameId = document.getElementById("app").dataset.gameId
        ```
    - That actually worked, pretty proud of that. Now I can
        ```
        let channel = socket.channel(`lobby_game:{$gameId}`, {})
        ```
    - Is there a more standard way to pass stuff from the html to the .js file that loads it? In the script tag or with window.variable? (I tried those and couldn't get it to work but maybe I did it wrong)

  - I couldn't get `import { sanitize } from "./app.js"` to work so I could make a DRY sanitize function in one file

  - Is this "...Loading" and wait for the javascript to fill-in right?
    - Originally I did everything with controller. Refresh page with params to do a thing, that changes @assigns and reloads the page
      - But, no OTHER browsers looking at that same page get updated
    - SO, time for channels
      - I tear out the controller way of doing it, attach a js function to the button that used to send a up to the controller, and now it'll all be done in js
      - But that makes the ...Loading flash, and there's no like, option to do EITHER the controller OR the js. Should I care about that?

# 2024-10-19
- Move scropt out of heex templates, and back into root.html using assigns for different ones
  - [Similar example](https://elixirforum.com/t/add-page-specific-js-files-on-phoenix-1-7/54900/6)
- Rename user_socket.js to more specifc to page. page_socket or page_js or something

- Maybe solve some of the RoundTest problems (pipeline with {} returns) with a bang! api option in the Round module (One that returns the usual {}, but another def that returns just the one thing, not the full {}

- LobbyGameController working good progress! Next todos:
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

  - "Loading..." THEN the javascript adds. Should I have the controller fill it in AND javascript. Maybe using the tmplate since I do have that. idk. It's weird to have it in both but maybe the loading is annoying

  - Lobby, dynamicsupervisor, but needs a tiny bit of state, the increment/gameId #. genserver just for that? Nameing. Lobby or gamesupervisor or something, then the genserver. Or maybe it's agent in same module, but then it's cluttered

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

