import {Socket} from "phoenix"

const NEW_GAME = "NEW_GAME"


function create_game(track_id) { channel.push("create_game", track_id) }

function create_and_join_game(track_id) { channel.push("create_and_join_game", track_id) }

function delete_game(gameId) { channel.push("delete_game", gameId) }


function appendGame(gameWrapper) {
  const game_row = makeGameRow(gameWrapper, NEW_GAME)
  gameContainer.prepend(game_row)
}

function drawGamesFromScratch(games) {
  gameContainer.innerHTML = ""
  games.map( (gameWrapper) => {
    const game_row = makeGameRow(gameWrapper, null)
    gameContainer.appendChild(game_row)
  })
}

function makeGameRow(gameWrapper, newGame) {
  const gameId = gameWrapper.name
  const gameCreator = gameWrapper.creator
  const gamePlayers = gameWrapper.players
  const trackId = gameWrapper.track_id

  const element = document.getElementById("game-template").content.cloneNode(true).firstElementChild

  element.dataset.gameId = gameId
  if (newGame) {
    element.classList.add("games__game--new")
  }

  element.querySelector(".gameLink").href = `/lobby/game/${gameId}`
  element.querySelector(".gameId").innerHTML = gameId
  element.querySelector(".track-id").innerHTML = trackId
  element.querySelector(".gameCreator").innerHTML = sanitize(gameCreator)

  element.querySelector(".join-game").addEventListener("click", _resp => { channel.push("join_game", gameId) })
  element.querySelector(".leave-game").addEventListener("click", _resp => { channel.push("leave_game", gameId) })
  element.querySelector(".delete-game").addEventListener("click", _resp => { delete_game(gameId) })

  // NOTE switch this to another template/clone if it gets more complicated than <span>Player1</span>
  element.querySelector(".gamePlayers").innerHTML = ""
  if (gamePlayers.length == 0) {
    const span = document.createElement("span")
    span.innerHTML = "..."
    element.querySelector(".gamePlayers").appendChild(span)
  } else {
    gamePlayers.map( (player) => {
      const span = document.createElement("span")
      span.innerHTML = sanitize(player)
      element.querySelector(".gamePlayers").appendChild(span)
    })
  }

  return element
}


let gameContainer = document.querySelector("#game-list")
let socket = new Socket("/socket", {params: {token: window.userToken}})
socket.connect()

let channel = socket.channel("lobby:main", {})
channel.join()
  .receive("ok", games => {
    drawGamesFromScratch(games)
  })
  .receive("error", resp => { console.log("Unable to join", resp) })

channel.on("game_created", gameWrapper => {
  appendGame(gameWrapper)
})

channel.on("game_updated", gameWrapper => {
  const gameRow = makeGameRow(gameWrapper, null)
  document.querySelector(`[data-game-id="${gameWrapper.name}"]`).replaceWith(gameRow)
})

channel.on("game_deleted", payload => {
  let target = document.querySelector(`[data-game-id="${payload.game_id}"]`)
  target.remove()
})


function sanitize(string) {
  return string.replace(/</g,"&lt;")
}

window.create_game = create_game
window.create_and_join_game = create_and_join_game
window.delete_game = delete_game
export default socket
