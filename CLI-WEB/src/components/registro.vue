<template>
    <h4><font-awesome-icon :icon="['fas', 'user-plus']" /> Registro</h4>
    <br>
    <form @submit.prevent="registrar" id="form">
        <label for="nombre">Nombre:</label>
        <input id="nombre" name="nombre" required v-model="user.nombre" />
        <br>
        <label for="apellido">Apellido:</label>
        <input id="apellido" name="apellido" required v-model="user.apellido" />
        <br>
        <label for="email">Email:</label>
        <input id="email" name="email" type="email" required v-model="user.email" />
        <br>
        <label for="pass">Contraseña: </label>
        <input type="password" required id="pass" name="pass" v-model="user.contra">
        <br>
        Alumno
        <label class="switch " id="tipo" name="tipo">
            <input type="checkbox" v-model="tipo">
            <span class="slider round"></span>
        </label>
        Entrenador
        <br>
        <div class="error" v-if="error"> {{ this.error }}</div>
        <button class="boton btn " type="submit">Registrarse</button>


    </form>
    <loading v-model:active="isLoading" :can-cancel="false" :is-full-page="true" />
    <br>
    <button @click="login(true)" class="boton btn"><font-awesome-icon :icon="['fas', 'door-open']" /> Iniciar
        sesión</button>
</template>

<script>
import Loading from 'vue-loading-overlay';
import 'vue-loading-overlay/dist/css/index.css';
import { state, socket } from "@/socket.js";
export default {
    name: 'registro',
    data() {
        return {
            isLoading: false,
            error: false,
            user: { nombre: "", apellido: "", email: "", tipo: 0, contra: "" },
            tipo: false
        }
    },
    props: [
        "login"
    ],
    components: {
        Loading
    },

    methods: {

        registrar() {
            this.isLoading = true
            if (this.tipo) {
                this.user.tipo = 0
            } else { this.user.tipo = 1 }
            fetch(this.$store.state.connection + 'usuario', {
                method: 'POST',
                headers: {
                    'Accept': 'application/json',
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(this.user)
            })
                .then(response => {
                    return response.json();
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


