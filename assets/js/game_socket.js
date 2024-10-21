import {Socket} from "phoenix"

const gameId = document.getElementById("app").dataset.gameId
const playerListElement = document.getElementById("player-list")


let socket = new Socket("/socket", {params: {token: window.userToken}})
socket.connect()

let channel = socket.channel(`lobby_game:${gameId}`, {})
channel.join()
  .receive("ok", resp => { drawPlayers(resp.players) })
  .receive("error", resp => { console.log("Unable to join", resp) })

channel.on("player_joined", resp => { drawPlayers(resp.players) })


document.getElementById("join-button").addEventListener("click", (resp) => {
  channel.push("join")
})


function drawPlayers(players) {
  playerListElement.textContent = ""

  players.map( (player) => {
    const playerRow = document.getElementById("player-template").content.cloneNode(true).firstElementChild

    // playerRow.querySelector("
    playerRow.textContent = sanitize(player)
    // playerRow.textContent = player

    playerListElement.appendChild(playerRow)
  })
}

function sanitize(string) {
  return string.replace(/</g,"&lt;")
}

export default socket
