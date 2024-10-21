import {Socket} from "phoenix"


let socket = new Socket("/socket", {params: {token: window.userToken}})
socket.connect()

let channel = socket.channel("room:lobby", {})
channel.join()
  .receive("ok", resp => {
  })
  .receive("error", resp => { console.log("Unable to join", resp) })


export default socket
