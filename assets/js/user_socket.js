import {Socket} from "phoenix"


function create_game(track_id) {
  channel.push("create_game", track_id)
}

let gameContainer = document.querySelector("#game_list")
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


window.create_game = create_game
export default socket
