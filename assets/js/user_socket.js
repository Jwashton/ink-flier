import {Socket} from "phoenix"

const NEW_GAME = "NEW_GAME"

function create_game(track_id) {
  channel.push("create_game", track_id)
}

function delete_game(gameId) {
  channel.push("delete_game", gameId)
}

function appendGame(gameWrapper) {
  let game_row = document.createElement("div")
  setHtml(game_row, gameWrapper.id, gameWrapper.creator, NEW_GAME)
  gameContainer.prepend(game_row)
}

function drawGamesFromScratch(games) {
  drawGames(games, null)
}

function drawGames(games, new_game_id) {
  gameContainer.innerHTML = ""
  games.map((game) => {
    let game_row = document.createElement("div")
    setHtml(game_row, game.id, game.creator, new_game_id)
    gameContainer.appendChild(game_row)
  })
}

function setHtml(element, gameId, gameCreator, newGame) {
  element.dataset.gameId = gameId
  element.classList.add("games__game")
  if (newGame) {
    element.classList.add("games__game--new")
  }
  element.innerHTML = `
    <span>
      Game number: ${gameId}
    </span>
    <span>
      Creator: ${sanitize(gameCreator)}
    </span>
    <span>
      <button onclick="delete_game(${gameId})">Delete</button>
    </span>
  `
}

function sanitize(string) {
  return string.replace(/</g,"&lt;")
}


let gameContainer = document.querySelector("#game-list")
let socket = new Socket("/socket", {params: {token: window.userToken}})
socket.connect()

let channel = socket.channel("room:lobby", {})
channel.join()
  .receive("ok", games => {
    drawGamesFromScratch(games)
  })
  .receive("error", resp => { console.log("Unable to join", resp) })

channel.on("game_created", gameWrapper => {
  appendGame(gameWrapper)
})

channel.on("game_deleted", gameId => {
  console.log(`Received game_delete: ${gameId}`)
  document.querySelector(`[data-gameId="${gameId}"]`).remove()
})


window.create_game = create_game
window.delete_game = delete_game
export default socket
