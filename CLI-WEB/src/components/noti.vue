<template >
    <div class="container ent  " v-bind:class="{ sinLeer: this.$store.state.session.tipo==0 && this.notificacion.visto==0 }">
        <div class="row">
            <div class="col-10">
                <p>{{ desc() }}</p>

                <p v-if="this.$store.state.session.tipo==1">De: {{ notificacion.entrenador.nombre }} {{ notificacion.entrenador.apellido }} </p>
                <p>Fecha: {{ fecha(notificacion.fecha) }}</p>
                
            </div>
            <div class="col-1 d-flex d-flex  align-items-center ml-auto">
                <font-awesome-icon :icon="['fas', 'chevron-right']" />
            </div>

        </div>
    </div>
</template>
<script>
import moment from 'moment'
export default {
    name: 'Noti',
    props: [
        "notificacion"
    ],
    methods: {
        desc() {
            if (this.notificacion.contenido > 100) {
                return this.notificacion.contenido.slice(0, 99) + "..."
            }
            return this.notificacion.contenido
        },
        fecha(f) {
            let fe = new Date(f)
            let hora = new Date(fe.getTime() + 3 * 60 * 60 * 1000)
            return moment(hora).format("DD/MM/YYYY h:mm a")
        },
    }

}
</script>