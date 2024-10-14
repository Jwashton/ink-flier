import {Socket} from "phoenix"


function create_game(track_id) {
  channel.push("create_game", track_id)
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

function drawGames(games) {
  games.map((game) => {
    let div = document.createElement("div")
    setHtml(div, game.id, game.creator)
    console.log(`Games: ${game.id}, ${game.creator}`)
    gameContainer.appendChild(div)
  })
}

channel.on("game_created", payload => {
  let gameItem = document.createElement("div")
  gameItem.innerText = "..."
  gameContainer.prepend(gameItem)
})

let testTarget = document.querySelector("#test-target")
setHtml(testTarget, 123, "Bobbb")

function setHtml(element, gameId, gameCreator) {
  element.classList.add("games__game")
  element.innerHTML = `
    <span class="games__game-data">
      Game number: ${gameId}
    </span>
    <span class="games__game-data">
      Creator: ${gameCreator}
    </span>
  `
}

window.create_game = create_game
export default socket
