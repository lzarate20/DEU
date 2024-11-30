<template >
    <div class="container " v-if="this.$store.state.notificacion!=null" tabindex="-1" :id=" this.$store.state.notificacion.id" :name=" this.$store.state.notificacion.id">
        <div>
            <br>
            <p v-if="this.$store.state.session.tipo==1">Notificacion de : {{  this.$store.state.notificacion.entrenador.nombre }} {{  this.$store.state.notificacion.entrenador.apellido }}</p>
            <br>
            Fecha: {{ fecha(this.$store.state.notificacion.fecha) }}
            <br>
            <br>
            {{ this.$store.state.notificacion.contenido }}
            <br>
            <br>
            <p v-if="this.$store.state.session.tipo==0">Alumnos:</p>
            <div v-if="this.$store.state.session.tipo==0" v-for="(n, index) in this.$store.state.notificacion.Alumnos" :key="index">
                <p>{{ n.nombre }} {{ n.apellido }} {{ visto[n.visto] }}</p>
            </div>
        </div>
    </div>
</template>
<script>
import Ejercicio from './ejercicio.vue'
import moment from 'moment'
export default {
    name: 'notificacion',
    components:{
        Ejercicio
    },
    data() {
        return {
            visto:["sin leer","leído"]
        }
    },
    methods: {
        fecha(f) {
            let fe = new Date(f)
            let hora = new Date(fe.getTime() + 3 * 60 * 60 * 1000)
            return moment(hora).format("DD/MM/YYYY h:mm a")
        },
    },
    mounted() {
       console.log("aaa")
    }
}
</script>