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
                    <notif :notificaciones="noti" v-if="this.$store.state.session != null"></notif>
                </div>
            </div>
        </div>
    </div>
</template>
<script>
import notif from '@/components/notif.vue'
import notificacion from '@/components/notificacion.vue'
export default {
    name:'ListadoNotificaciones',
    created() {
        if(this.$store.state.session==null){
            
           this.$router.replace("home");
        }
    },
    data() {
        return {
            noti:[]
        }
    },
    components: {
        notif,
        notificacion,
    },
    methods: {
        compare(a, b) {
            let fa = Date.parse(a.fecha)
            let fb = Date.parse(b.fecha)
            if (fa > fb) {
                return -1;
            }
            if (fa > fb) {
                return 1;
            }
            // a debe ser igual b
            return 0;
        },
        getNotificaciones() {
            fetch(this.$store.state.connection + 'notificacion_entrenador/' + this.$store.state.session.id, {
                method: 'Get',
                headers: {
                    'Accept': 'application/json',
                    'Content-Type': 'application/json',

                }
            })
                .then(response => {

                    return response.json();
                })
                .then(json => {
                    if (json.error) {
                        this.error = json.error
                    } else {
                        this.noti =  JSON.parse(JSON.stringify(json.Notificaciones)).sort(this.compare)
                    }
                })
                .catch(error => {
                    console.log(error)
                })
        },
       
    },
    mounted() {
        this.getNotificaciones()
    },
    }
</script>