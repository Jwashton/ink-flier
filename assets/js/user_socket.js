import {Socket} from "phoenix"


function create_game(track_id) {
  channel.push("create_game", track_id)
}

function drawGames(games) {
  gameContainer.innerHTML = ""
  games.map((game) => {
    let new_game_row = document.createElement("div")
    setHtml(new_game_row, game.id, game.creator)
    gameContainer.appendChild(new_game_row)
  })
}

function setHtml(element, gameId, gameCreator) {
  element.classList.add("games__game")
  if (gameId == 4) {
    element.classList.add("games__game--new")
  }
  element.innerHTML = `
    <span class="games__game-data">
      Game number: ${gameId}
    </span>
    <span class="games__game-data">
      Creator: ${gameCreator}
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
  let gameItem = document.createElement("div")
  gameItem.innerText = "..."
  gameContainer.prepend(gameItem)
})


window.create_game = create_game
export default socket
