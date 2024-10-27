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
