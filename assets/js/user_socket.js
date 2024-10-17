import {Socket} from "phoenix"


function create_game(track_id) {
  channel.push("create_game", track_id)
}

function drawGames(games, new_game_id = null) {
  gameContainer.innerHTML = ""
  games.map((game) => {
    let game_row = document.createElement("div")
    setHtml(game_row, game.id, game.creator, new_game_id)
    gameContainer.appendChild(game_row)
  })
}

function setHtml(element, gameId, gameCreator, new_game_id) {
  element.classList.add("games__game")
  if (gameId == new_game_id) {
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

function delete_game(gameId) {
  channel.push("delete_game", gameId)
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
    drawGames(games)
  })
  .receive("error", resp => { console.log("Unable to join", resp) })

channel.on("game_created", payload => {
  console.log(JSON.stringify(payload))
  drawGames(payload.games, payload.new_game_id)
})


window.create_game = create_game
window.delete_game = delete_game
export default socket
