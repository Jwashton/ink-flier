# 2024-11-20
- [X] GameServer is now being created with TrackId. Display it on html of both Lobby and Game

# 2024-11-17
- Split lobby.css into 2 or 3 files, a main (with the colors), and then one for each page
  - Pass that in as an @attr as a list or something
  - Basically use layout with the @attrs instead of doing \<script...\> at the top of the lobby and game pages
    - (Which means do the above for their css AND .js)
  - Start with the JS since it'll be easier 1-to-1
  - Then do the css which'll have a MAIN for each, then a second page-specific css for each

# 2024-11-15
- [X] After that I might flatten LobbyServer into just a context, not a process, like William & I talked about and have notes below

# 2024-11-13
- Finish extracting the shared setup for channels, currently stuck in git stash
- Finish "No broadcast for removing players that haven't joined" in gameChannelTest

# 2024-11-12
- [X] Game page's Js: channel.on for the game_deleted event
- [X] Prob do move lobby_server's `:ok = GameChannel.notify_game_deleted(game_id)` to GameSupervisor.delete_game
  - And instead of taking pid, take gameName, (update the few places that call that to not need to pass in whereis first)
  - And then just use GameServer.via should work
  - Note that the GenServer.terminate also prob would have been fine. I like the Supervisor being in charge of it more tho
- [X] At some point, I broke the "x" kick other player out of game from Game page, double check that
  - Write test if possible. The broadcast event might be fine tho and it's just a js not wired up right
- [X] Next, continue game_channel_test.exs
  - I can write a test (and then actually implement) graceful channel (or router or something) redirects when we try to connect to a game id that doesn't exist/was deleted
- [X] After removing the @name stuff from all the tests (and the one channel I had to use non-default name-filled-in 1st arg)
  - go through the processes themselves and make sure there's no lingering @name stuff

# 2024-10-30
- Player joining from the game page sends a live javascript update even to people on the lobby page, refreshing it's game for just that row!

# 2024-10-28
- Remember, I got stuck/frustrated/lostMomentum the first time through LobbyServer-controlls-real-game-processes
  - Instead of a) nuking everything and rebuilding ALL from scratch, or b) Trying to jam fixes into the fully broken bits
    - I went in the middle of the spectrum
    - Made a Lobby2 from scratch, but KEPT Lobby1 doing it's wrong-but-working-and-lookAtAble stuff
    - Built everything I needed in the nice clean Lobby2
    - Until eventually lobby1 was redundant, I could kill and replace it with #2
    - Then I found the few lingering broken things where the api had changed slightly (all the functions/processes take keyword lists, instead of sometimes tuples and sometimes maps, etc), and made the small fix to reconnect outside api-calling users, basically the channels

- Got all the LobbyServer (Lobby state) -> GameSupervisor -> GameServer(Game state) working together! :)

- Lobby can delete games again
  - Note that these are now REAL game processes whose pages you could actually go and interact with, not the dummy placeholder game atoms that lobby worked with before

- Show the actual player list of each game in Lobby
  - Updating it on change in the game will be the next fun big thing, the cross-process messages stuff
  - But for now just on normal page refresh I am able to at least get the current player list

# 2024-10-27
- Got Lobby creating games sucessfully
  - Managed the heirchy of: LobbyServer (Lobby) -> GameSupervisor -> GameServer (Game)
  - DIDN'T delete all my everything and start from scratch when I got frustrated
  - Made a "Lobby2" second module, soft-restarted in there, got it working IN PARALLEL with the old one which did still partially work and I did want to look at it's running pages for reference while working on #2
  - Once #2 did everything I needed, I killed #1, renamed #2, and then rehooked the frontend pieces (channel) whose api calls down to lobby had changed slightly
  - Managed to do it in small pieces at a time and got my momentum back up nicely! <3
- Lobby actually starts and tracks new game processes, and sure enough those can do their own calls of "add and remove player". It's actually working, this is very very cool :)

# 2024-10-26
- (solved!)(1) Intermitently failing GenServer/process tests, because I think it's taking an extra second to stop in the background and not finished before next test runs (or something?)
      ```
      test/ink_flier/lobby_server2_test.exs:29
      ** (MatchError) no match of right hand side value: {:error, {:already_started, #PID<0.596.0>}}
      ```
  - It's the {:ok...} = GameSupervisor.start_game (in LobbyServer.handlecall.start_game)
    - Sometimes GameSupervisor (the dynamicsupervisor) is saying that game's already started
    - But it's making them with via and what should be a unique id
    - (1) Oh hello. I was looking at setup->on_exit in exunit, but there's ACTUALLY a start_supervised
      - instead of me manually doing
          setup do
            {:ok, _} = GameSupervisor.start_link(name: @game_starter)
            :ok
          end
      - [X] test start_supervised stuff
        - By any chance can I remove the `name:` stuff I had to put in ONLY for tests to run their own copy
          - Can start_supervised start it's own version of a thing that was started in Application
          - Even if it can, keep the OPTION in my genservers. Also prob keep calling it like I have been in tests even if don't have to. I think I need to at least for LobbyServer2 since he needs to know the name of game_supervisor
          - Answer: It doesn't stop stuff from application. It will, somewhat correctly&expectedly, error if you try to start_supervised! something started in application WITHOUT using the awesome `name: TestVersion...` override trick

# 2024-10-22
- LobbyGameController/channel
  - no double-joins by same player
  - And leave game
  - A 2nd version of remove player where anyone can remove any name (in addition to "leave" which only removes logged in user)
  - lobbyGameHtml- in js, remove the remove_player button if it's this user's row

- Sucessfully finish "channel broadcasts for player leaving (or being removed) from a game"