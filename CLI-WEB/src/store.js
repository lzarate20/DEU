import { createStore } from 'vuex'

export default createStore({
    state: {
        connection: "",
        session: null,
        entrenamiento:null,
        notificacion:null,
        notificaciones:[],
        id_config:1,
        modo:1,
        alumno:null
    },
    mutations: {
        SET_CONNECTION(state) {
            let conn
            if (location.hostname === "localhost" || location.hostname === "127.0.0.1") {
                conn = "http://localhost:4000/"
            }
            else {
                conn = "api/"
            }
            state.connection = conn
        },
    },
    actions: {
    },
    modules: {
    },
})
