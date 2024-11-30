<template>
    <nav class="nav navbar sticky-top ">

        <ul class="navbar-nav mr-auto">
            <li class="nav-item active">
                <div style="padding:0rem .5rem" @click="$router.go(-1)" role="button" aria-label="volver" tabindex="0"><font-awesome-icon :icon="['fas', 'arrow-left']" />
                </div>
            </li>
        </ul>

        <router-link class="navbar-brand" to="/" aria-label="ir a pagina principal">Inicio</router-link>
        <ul class="navbar-nav  ml-auto list-group  " style="right: 0;flex-direction: row; ">
            <li class="nav-item dropdown" v-if="this.$store.state.session != null">
                <a role="button" tabindex="0" class="nav-link dropdown-toggle " style="padding:0rem .5rem" href="#" id="navbarDropdown"
                    data-toggle="dropdown" aria-haspopup="true" aria-expanded="false" aria-label="configuración de usuario">
                    <font-awesome-icon :icon="['far', 'user']" />
                </a>
                <div class="dropdown-menu" aria-labelledby="navbarDropdown">
                    <a role="button" tabindex="0" v-on:keyup.enter="modals('editPerfil')" class="dropdown-item" data-toggle="modal" data-target="#editPerfil">
                        <font-awesome-icon :icon="['fas', 'user-pen']" />
                        Editar
                        Perfil</a>
                    <div class="dropdown-divider"></div>
                    <a role="button" tabindex="0" v-on:keyup.enter="modals('cambiarPass')" class="dropdown-item" data-toggle="modal" data-target="#cambiarPass"> <font-awesome-icon
                            :icon="['fas', 'key']" /> Cambiar
                        Contraseña</a>
                    <div class="dropdown-divider"></div>
                    <a to="#" role="button" tabindex="0" v-on:keyup.enter="modals('config'); modal()" class="dropdown-item" data-toggle="modal" data-target="#config" @click="() => { modal() }">
                        <font-awesome-icon :icon="['fas', 'gear']" /> Configuración</a>
                    <div class="dropdown-divider"></div>
                    <a to="#"   role="button" tabindex="0" v-on:keyup.enter="cerrarSesion()" class="dropdown-item" @click="cerrarSesion()"><font-awesome-icon
                            :icon="['fas', 'door-closed']" /> Cerrar Sesión</a>
                </div>
            </li>
        </ul>

    </nav>
    <div class="modal  " id="editPerfil" tabindex="-1" role="dialog">
        <div class="modal-dialog modal-dialog-centered modal-md" role="presentation">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title"><font-awesome-icon :icon="['fas', 'user-pen']" /> Editar perfil </h5>
                    <button type="button" class="close boton" @click="cerrar()" data-dismiss="modal" aria-label="Cerrar">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <div class="container">
                        <div class=" justify-content-center " v-if="this.$store.state.session != null">
                            <form @submit.prevent="save">
                           
                                <p> <label for="nombre" >Nombre: </label> <input required v-model="this.$store.state.session.nombre" id="nombre" name="nombre" /></p>
                                
                                <p><label for="apellido">Apellido: </label> <input id="apellido" name="apellido" required v-model="this.$store.state.session.apellido" /></p>
                             
                                <p><label for="email">Email: </label><input required id="email" name="email" v-model="this.$store.state.session.email" /></p>
                                <p><button class="boton btn " type="submit">Guardar</button></p>

                            </form>
                        </div>
                        <p id="mensaje" name="mensaje"></p>
                    </div>
                    <br>

                </div>
            </div>
        </div>
    </div>
    <div class="modal  " id="config" tabindex="-1" role="dialog">
        <div class="modal-dialog modal-dialog-centered modal-md" role="presentation">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title"> <font-awesome-icon :icon="['fas', 'gear']" /> Configuración </h5>
                    <button type="button" class="close boton" @click="cerrar()" data-dismiss="modal" aria-label="Cerrar">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <div class="container">
                        <div class=" justify-content-center ">
                            <label for="tema">Tema</label>
                            <br>
                            <div class=" justify-content-center d-flex d-flex  align-items-md-center">
                                <font-awesome-icon style="margin:0 1rem " :icon="['fas', 'sun']" />
                                <label class="switch ">
                                    <input type="checkbox" id="tema" name="tema" @change="aplicar()" aria-label="Tema oscuro">
                                    <span class="slider round"></span>
                                </label>
                                <font-awesome-icon style="margin:0 1rem " :icon="['fas', 'moon']" />
                            </div>
                        </div>
                        <br>
                        <div class=" justify-content-center ">
                            <label for="tam">Tamaño de fuente</label>
                            <br>
                            <div class="range" style="--step:.25; --min:0.5; --max:2">
                                <input type="range" id="tam" name="tam" value="1" min=".5" max="2" step="0.25" list="value"
                                    @change="aplicar()" >

                            </div>

                            <datalist id="value" style="margin:auto">
                                <div v-for="i in ((2 - .25) / .25)" :key="i">
                                    <option v-bind:value="Math.floor(i * 100 / ((2 - .25) / .25))"
                                        v-bind:label=".25 * i + .25"></option>
                                </div>
                            </datalist>
                        </div>
                    </div>
                    <br>

                </div>
                <div class="modal-footer justify-content-center">
                    <button class="btn btn-danger" data-dismiss="modal" @click="cerrar()">Cancelar</button>
                    <button class="boton btn" data-dismiss="modal" @click="guardar()">Guardar</button>
                </div>
            </div>
        </div>
    </div>

    <div class="modal  " id="cambiarPass" tabindex="-1" role="dialog">
        <div class="modal-dialog modal-dialog-centered modal-md" role="presentation">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title"><font-awesome-icon :icon="['fas', 'key']" /> Cambiar
                        Contraseña </h5>
                    <button type="button" class="close boton" @click="cerrar()" data-dismiss="modal" aria-label="Cerrar">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <div class="container">
                        <div class=" justify-content-center ">
                            <form @submit.prevent="pass">
                                <p><label for="contra">Contraseña: </label><input type="password" required name="contra" id="contra" /></p>
                                
                                <p><label for="new_contra">Nueva contraseña: </label><input type="password" required name="new_contra" id="new_contra" /></p>
                                
                                <p><label for="rp_contra">Repita la contraseña: </label><input type="password" required name="rp_contra" id="rp_contra" /></p>
                                <p><button class="boton btn " type="submit">Guardar</button></p>

                            </form>
                        </div>
                        <p id="sms" name="sms"></p>
                    </div>
                    <br>

                </div>
            </div>
        </div>
    </div>
    <loading v-model:active="isLoading" :can-cancel="false" :is-full-page="true" />
</template>
<script>
import Loading from 'vue-loading-overlay';
import {  socket } from "@/socket.js";
export default {
    name: 'Navbar',
    data() {
        return {
            isLoading: false,
            modo: this.$store.state.modo,
            fuente: 1,
            id_config: this.$store.state.id_config,
            user: this.$store.state.session,
        }
    },
    components: {
        Loading
    },
     
    methods: {
        modals(m) {
            var myModal = new bootstrap.Modal(document.getElementById(m), {
                keyboard: false
            })
            myModal.show()
        },
        guardar() {
            this.isLoading = true
            this.modo = 0
            if (!tema.checked) this.modo = 1
            this.color(this.modo)
            localStorage.setItem("modo", this.modo)
            this.$store.state.modo = this.modo
            this.fuente = tam.value
            body.style.fontSize = this.fuente + "em"
            localStorage.setItem("fuente", this.fuente)
            fetch(this.$store.state.connection + 'config_editar', {
                method: 'POST',
                headers: {
                    'Accept': 'application/json',
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({ id: this.$store.state.id_config, us: this.$store.state.session.id, tema: this.modo })
            })
                .then(response => {
                    return response.json();
                })
                .then(json => {
                    if (json.error) {
                        this.error = json.error
                    }
                    console.log("guardar")
                })
                .catch(error => {
                    console.log(error)
                })
            this.isLoading = false
        },
        aplicar() {
            let modo = 0
            if (!tema.checked) modo = 1
            this.color(modo)
            let fuente = tam.value
            body.style.fontSize = fuente + "em"
        },
        modal() {
            if (this.modo == 0) tema.checked = true
            tam.value = this.fuente
        },
        cerrar() {
            this.color(this.modo)
            body.style.fontSize = this.fuente + "em"
            this.modal()
        },
        cerrarSesion() {

            localStorage.removeItem('sesion')
            localStorage.removeItem('fuente')
            localStorage.removeItem('modo')
            this.$store.state.session = null
            this.$router.replace("home");
            socket.disconnect()
            location.replace("/")
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

        emitValue() {
            this.$emit('update:user', user)
        },
        save() {
            fetch(this.$store.state.connection + 'usuario_editar', {
                method: 'POST',
                headers: {
                    'Accept': 'application/json',
                    'Content-Type': 'application/json',

                },
                body: JSON.stringify({ nombre: this.user.nombre, apellido: this.user.apellido, email: this.user.email, contra: this.user.contra, id: this.user.id, posicion: this.user.posicion, tipo: this.user.tipo })
            })
                .then(response => {

                    return response.json();
                })
                .then(json => {
                    if (json.error) {
                        this.error = json.error
                        mensaje.innerText = json.error
                    } else {
                        mensaje.innerText = "Usuario editado correctamente"
                        this.$store.state.session = json
                        localStorage.setItem("sesion", JSON.stringify(json))
                    }
                })
                .catch(error => {
                    mensaje.innerText = "Lo sentimos ocurrió  un error inesperado"
                })
        },
        pass() {
            fetch(this.$store.state.connection + 'usuario_editar_pass', {
                method: 'POST',
                headers: {
                    'Accept': 'application/json',
                    'Content-Type': 'application/json',

                },
                body: JSON.stringify({ id: this.user.id, contra: contra.value, new_contra: new_contra.value, rp_contra: rp_contra.value })
            })
                .then(response => {

                    return response.json();
                })
                .then(json => {
                    if (json.error) {
                        this.error = json.error
                        sms.innerText = json.error
                    } else {
                        sms.innerText = json
                    }
                })
                .catch(error => {
                    sms.innerText = "Lo sentimos ocurrió  un error inesperado"
                })


        }
    },
    mounted() {

        this.fuente = localStorage.getItem("fuente")
    },

}
</script>