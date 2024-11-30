import { reactive } from "vue";
import { io } from "socket.io-client";

export const state = reactive({
  connected: false,
  notificaciones: []
});

let URL
if (location.hostname === "localhost" || location.hostname === "127.0.0.1") {
    URL = "http://localhost:4000/"
}
else {
    URL = "api"
}

export const socket = io(URL);

socket.on("connect", (auth) => {
  
});

socket.on("disconnect", () => {
  state.connected = false;
});


socket.on("coneccion", () => {
  state.connected = true;
});
socket.on("notificacion", (sms) => {
  console.log(state.notificaciones)
  state.notificaciones.push(sms);
});