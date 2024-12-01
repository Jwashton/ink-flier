import {Socket} from "phoenix"

const gameId = document.getElementById("app").dataset.gameId
const user = document.getElementById("app").dataset.user
const playerListElement = document.getElementById("player-list")
const messageContainer = document.getElementById("messages")


let socket = new Socket("/socket", {params: {token: window.userToken}})
socket.connect()

let channel = socket.channel(`game:${gameId}`, {})
channel.join()
  .receive("ok", resp => { drawPlayers(resp.players) })
  .receive("error", resp => { console.log("Unable to join", resp) })


channel.on("players_updated", resp => { drawPlayers(resp.players) })

channel.on("game_deleted", _resp => {
  messageContainer.value += `\n[${formattedDateTime()}] This game has been deleted. Please refresh page or return to lobby.`
})

channel.on("game_started", _resp => { location.reload() })

document.getElementById("join-button").addEventListener("click", (resp) => { channel.push("join") })
document.getElementById("leave-button").addEventListener("click", (resp) => { channel.push("leave") })
document.getElementById("start").addEventListener("click", (resp) => { channel.push("start") })


function drawPlayers(players) {
  playerListElement.textContent = ""

  players.map( (player) => {
    const playerRow = document.getElementById("player-template").content.cloneNode(true).firstElementChild

    playerRow.querySelector(".player_name").innerHTML = sanitize(player)

    if (player == user) {
      playerRow.querySelector("#remove_button")
      .remove()
    } else {
      playerRow.querySelector("#remove_button")
      .addEventListener("click", (_resp) => { channel.push("leave", {target: player}) })
    }

    playerListElement.appendChild(playerRow)
  })
}

function sanitize(string) {
  return string.replace(/</g,"&lt;")
}

function formattedDateTime() {
  // Source: https://www.google.com/search?q=javascript+simple+date+and+time

  const now = new Date();

  // Get the date components
  const year = now.getFullYear();
  const month = now.getMonth() + 1; // Months are 0-indexed
  const day = now.getDate();

  // Get the time components
  const hours = now.getHours();
  const minutes = now.getMinutes();
  const seconds = now.getSeconds();

  // Format the date and time
  const formattedDate = `${year}-${month.toString().padStart(2, '0')}-${day.toString().padStart(2, '0')}`;
  const formattedTime = `${hours.toString().padStart(2, '0')}:${minutes.toString().padStart(2, '0')}:${seconds.toString().padStart(2, '0')}`;

  return `${formattedDate} ${formattedTime}`
}

export default socket
