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
