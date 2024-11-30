<template>
    <h4><font-awesome-icon :icon="['fas', 'door-open']" /> Iniciar sesión</h4>
    <br>
    <form @submit.prevent="iniciarSesion" id="form">
        <label for="email">Email: </label>
        <input type="text" id="email" name="email" required>
        <br>
        <label for="pass">Contraseña: </label>
        <input type="password" required id="pass" name="pass">
        <div class="error" v-if="error"> {{ this.error }}</div>
        <br>
        <button class="boton btn " type="submit">Iniciar Sesión</button>

    </form>
    <loading v-model:active="isLoading" :can-cancel="false" :is-full-page="true" />
    <br>
    <button @click="login(false)" class="boton btn"><font-awesome-icon :icon="['fas', 'user-plus']" /> Registrarse</button>
</template>

<script>
import Loading from 'vue-loading-overlay';
import 'vue-loading-overlay/dist/css/index.css';
import axios from 'axios';
import { state, socket } from "@/socket.js";
export default {
    name: 'Login',
    data() {
        return {
            isLoading: false,
            error: false
        }
    },
    props: [
        "login"
    ],
    components: {
        Loading
    },

    methods: {

        iniciarSesion() {
            this.isLoading = true
            let email = document.getElementById("email").value
            let pass = document.getElementById("pass").value
            axios.post(this.$store.state.connection + 'login', {
              email: email,
              contra: pass
            }, {
              headers: {
                'Accept': 'application/json',
                'Content-Type': 'application/json'
              }
            })
                .then(response => {
                    return response.data
                })
                .then(json => {
                    if (json.error) {
                        this.error = json.error
                    } else {
                        localStorage.setItem('sesion', JSON.stringify(json))
                        this.$store.state.session = json
                        this.getConfig()
                        let user = this.$store.state.session
                        if (user !== null) {
                            socket.emit('coneccion', user.id)
                        }

                    }
                })
                .catch(error => {
                    console.log(error)
                })
            this.isLoading = false

        },
        color(modo) {
            if (modo == 0 || modo == null || modo == undefined) {
                document.documentElement.style.setProperty('--background', "#000");
                document.documentElement.style.setProperty('--text_nav', "#fff");
                document.documentElement.style.setProperty('--nav', "#333");
                document.documentElement.style.setProperty('--text', "#fff");
            } else {
                document.documentElement.style.setProperty('--background', "#fff");
                document.documentElement.style.setProperty('--text_nav', "#000a");
                document.documentElement.style.setProperty('--nav', "#d9d9d9");
                document.documentElement.style.setProperty('--text', "#000");
            }
        },
        getConfig() {

            fetch(this.$store.state.connection + "configByUser/" + this.$store.state.session.id)
                .then(response => {
                    return response.json();
                })
                .then(json => {
                    if (json.error == null) {

                        localStorage.setItem("modo", json.tema)
                        this.$store.state.modo = json.tema
                        this.$store.state.id_config = json.id
                        this.color(json.tema)
                    } else {
                        console.log(json.error)
                    }
                })
                .catch(error => {
                    console.log(error)
                })
        }
    }
}
</script>


