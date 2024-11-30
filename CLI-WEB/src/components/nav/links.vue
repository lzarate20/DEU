<template>
    <div class="links" id="enla" name="enla" @click="collapse"><a>Enlaces <font-awesome-icon :icon="['fas', 'bars']" /></a>
    </div>
    <div class="links" id="links" name="links">
        <ul class="ul-nombre ">
            <li>
                <div class="d-flex justify-content-start">Entrenamiento:</div>
                <ul class="ul-link">

                    <li class="d-flex justify-content-start" v-if="this.$store.state.session.tipo==0">
                        <router-link to="/crear_entrenamiento" class="link-box" active-class="link-box-active">Crear
                            entrenamiento</router-link>
                    </li>
                    <li class="d-flex justify-content-start">
                        <div>
                            <router-link to="/" class="link-box" active-class="link-box-active">Próximos entrenamientos</router-link>
                        </div>
                    </li>
                    <li class="d-flex justify-content-start">
                        <router-link to="/historial_entrenamientos" class="link-box" active-class="link-box-active">Historial de entrenamiento</router-link>
                    </li>

                </ul>

            </li>
        </ul>
        <ul class="ul-nombre " v-if="this.$store.state.session.tipo==0">
            <li>
                <div class="d-flex justify-content-start">Ejercicios:</div>
                <ul class="ul-link">
                    <li class="d-flex justify-content-start">
                        <router-link to="/crear_ejercicio" class="link-box" active-class="link-box-active">Crear
                            ejercicio</router-link>
                    </li>
                    <li class="d-flex justify-content-start">
                        <router-link to="/listado_ejercicios" class="link-box" active-class="link-box-active">Listado de
                            ejercicios</router-link>
                    </li>
                </ul>

            </li>

        </ul>
        <ul class="ul-nombre " v-if="this.$store.state.session.tipo==0">
            <li>
                <div class="d-flex justify-content-start">Alumnos:</div>
                <ul class="ul-link ">
                    <li class="d-flex justify-content-start">
                        <router-link to="/agregar_alumno" class="link-box" active-class="link-box-active">Agregar
                            alumno</router-link>

                    </li>
                    <li class="d-flex justify-content-start">
                        <router-link to="/listado_alumnos" class="link-box" active-class="link-box-active">Listado de
                            alumnos</router-link>

                    </li>
                </ul>

            </li>
        </ul>
        <ul class="ul-nombre ">
            <li>
                <div class="d-flex justify-content-start">Notificaciones:</div>
                <ul class="ul-link">
                    <li class="d-flex justify-content-start" v-if="this.$store.state.session.tipo==0">
                        <router-link to="/crear_notificacion" class="link-box" active-class="link-box-active">Crear
                            notificación</router-link>
                    </li>
                    <li class="d-flex justify-content-start" v-if="this.$store.state.session.tipo==0">
                        <router-link to="/listado_notificaciones" class="link-box" active-class="link-box-active">Listado de notificaciones</router-link>
                    </li>
                    <li class="d-flex justify-content-start" v-if="this.$store.state.session.tipo==1">
                        <Btn_noti></Btn_noti>
                    </li>
                </ul>

            </li>

        </ul>
    </div>
</template>
<script>
import Btn_noti from "@/components/btn_notificaciones.vue"
export default {
    name: 'Links',
    data() {
        return {
            collapsed: false
        }
    },
    components: {
        Btn_noti
    },
    methods: {
        collapse() {
            if (this.collapsed) {
                links.classList.remove("hidden")
            } else {
                links.classList.add("hidden")
            }
            this.collapsed = !this.collapsed
        }
    },
    mounted() {
        var mql = window.matchMedia('(max-width: 801px)');

        mql.addListener(function (event) {
            if (event.matches) { // La media querie coincide
                links.classList.add("hidden")
                this.collapsed = true
                enla.classList.remove("hidden")
            } else {
                enla.classList.add("hidden")
                this.collapsed = false
                links.classList.remove("hidden")
            }
        });
        let ancho = window.innerWidth
        if (ancho <= 801) {
            links.classList.add("hidden")
            this.collapsed = true
        } else {
            enla.classList.add("hidden")
            this.collapsed = false
        }
    },

} 
</script>
