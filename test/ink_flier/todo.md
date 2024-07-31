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

# 2024-06-28
- Track module
  - Struct: inner_wall & outer_wall
  - For each wall
    - List of coords, like svg:
      - # <polyline points="50,150 50,200 200,200 200,100"...
- Check collision between car and track
- Game/"context" module
  - Rules checks here
    - eg. use Car.legal_moves to confirm move is legal
  - Maybe genserver like the islands book, circle back to that
