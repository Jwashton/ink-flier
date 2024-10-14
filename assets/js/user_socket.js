import {Socket} from "phoenix"


function create_game(track_id) {
  channel.push("create_game", track_id)
}

let gameContainer = document.querySelector("#game-list")
let socket = new Socket("/socket", {params: {token: window.userToken}})
socket.connect()

let channel = socket.channel("room:lobby", {})
channel.join()
  .receive("ok", resp => { console.log("Joined successfully", resp) })
  .receive("error", resp => { console.log("Unable to join", resp) })

channel.on("game_created", payload => {
  let gameItem = document.createElement("div")
  gameItem.innerText = "..."
  gameContainer.prepend(gameItem)
})

let testTarget = document.querySelector("#test-target")
setHtml(testTarget, 123, "Bobbb")

function setHtml(element, gameId, gameCreator) {
  element.innerHTML = `
    <div class="games__game">
      <span class="games__game-data">
        Game number: ${gameId}
      </span>
      <span class="games__game-data">
        Creator: ${gameCreator}
      </span>
    </div>
    `
}

window.create_game = create_game
export default socket
