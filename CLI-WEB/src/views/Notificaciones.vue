<template>
    <div class="contenedor_c ">
        <div class="row u justify-content-center  ">
            <div class="col-md order-md-2 hijo  justify-content-center  ">
                <div>
                    <notificacion v-if="this.$store.state.session != null">
                    </notificacion>
                </div>
            </div>
            <div class="col-md order-md-1  hijo   justify-content-center d-flex  ">
                <div>
                    <notif v-bind:notificaciones="notificaciones" v-if="this.$store.state.session != null"></notif>
                </div>
            </div>
        </div>
    </div>
</template>
<script>
import notif from '@/components/notif.vue'
import notificacion from '@/components/notificacion.vue'
export default {
    name: 'Notificaciones',
    created() {
        if (this.$store.state.session == null) {

            this.$router.replace("home");
        }
    },
    computed: {
    notificaciones() {
      return this.$store.state.notificaciones
    },

  },
    components: {
        notif,
        notificacion,
    },
}
</script> 