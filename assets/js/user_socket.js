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
      Creator: ${gameCreator}
    </span>
    <span>
      <button onclick="delete(${gameId})">Delete</button>
    </span>
  `
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
  drawGames(payload.games, payload.new_game_id)
})


window.create_game = create_game
export default socket
