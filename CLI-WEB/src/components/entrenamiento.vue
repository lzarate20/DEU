<template >
    <div class="container " v-if="this.$store.state.entrenamiento!=null"  tabindex="-1" :id="this.$store.state.entrenamiento.id" :name="this.$store.state.entrenamiento.id">
        <div>
            {{ this.$store.state.entrenamiento.nombre }}
            <br> 
            {{ this.$store.state.entrenamiento.descripcion }}
            <br>
            Entrenamiento el dia:
            <br>
            {{ fecha(this.$store.state.entrenamiento.fecha) }}
            <br>
            <br>
            Calentamiento:
            <ul>
                <div v-for="(eje, index) in this.$store.state.entrenamiento.Ejercicios" :key="index">
                    <div v-if="eje.categoria==0">
                        <Ejercicio  :eje="eje"></Ejercicio>

                    </div>
                </div>
            </ul>
            <br>
           Entrenamiento:
            <ul>
                <div v-for="(eje, index) in this.$store.state.entrenamiento.Ejercicios" :key="index">
                    <div v-if="eje.categoria==1">
                        <Ejercicio role="button" tabindex="0" :eje="eje"></Ejercicio>

                    </div>
                </div>
            </ul>
            <br>
            Regenerativo:
            <ul>
                <div v-for="(eje, index) in this.$store.state.entrenamiento.Ejercicios" :key="index">
                    <div v-if="eje.categoria==2">
                        <Ejercicio role="button" tabindex="0" :eje="eje"></Ejercicio>

                    </div>
                </div>
            </ul>
        </div>
    </div>
</template>
<script>
import Ejercicio from './ejercicio.vue'
import moment from 'moment'
export default {
    name: 'Entrenamiento',
    components:{
        Ejercicio,
    },
    methods: {
        fecha(f){
            return moment(f).format("DD/MM/YYYY h:mm a")
        }
    },
    mounted() {
        let ent = ["Fuerza", "Velocidad", "Resistencia", "Estrategia"]
    }
}
</script>