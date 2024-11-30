<template >
    <div class="container ent  ">
        <div class="row">
            <div class="col-10">
                    <p>{{entrenamiento.nombre}}</p>
                    <p>Fecha: {{ fecha(entrenamiento.fecha) }}</p>
                    <p>Tipo: {{ tipo }}</p>
            </div>
            <div class="col-1 d-flex  align-items-center ml-auto">
                <font-awesome-icon :icon="['fas', 'chevron-right']" />
            </div>

        </div>
    </div>
</template>
<script>
import moment from 'moment'
export default {
    name: 'Ent',
    data() {
        return {
            tipo:null
        }
    },
    props: [
        "entrenamiento"
    ],
    methods: {
        fecha(f){
            return moment(f).format("DD/MM/YYYY h:mm a")
        }
    },
    mounted(){
        let ent=["Fuerza","Velocidad","Resistencia","Estrategia"]
        this.tipo=ent[this.entrenamiento.tipo]
    }
}
</script>