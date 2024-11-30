<template>
    <router-link to="/notificaciones" v-if="this.$route.path != '/notificaciones'"  >Notificaciones <font-awesome-icon :icon="['fas', 'bell']" />
        <span class='badge badge-warning' id='lblCartCount' > {{ sinLeer }} </span></router-link>
    <div v-if="this.$route.path == '/notificaciones'">Notificaciones <font-awesome-icon :icon="['fas', 'bell']" />
        <span class='badge badge-warning' id='lblCartCount' v-if="sinLeer != 0"> {{ sinLeer }} </span></div>
        <p hidden>{{ notificaciones }}</p>
</template>
<script>
import { state } from "@/socket.js";
export default {
    name: 'Btn_noti',
    data() {
        return {
            noti: new Array(),
            sinLeer: 0
        }
    },
    computed: {
        notificaciones() {
            let n = this.unionArray(this.noti, state.notificaciones)
            this.cantSinLeer(n)
           /* this.$store.state.notificaciones=n.sort(this.compare)
            return n.sort(this.compare)*/
        },

    },
    methods: {
        cantSinLeer(a) {
            this.sinLeer = 0
            a.forEach(e => {
                if (e.visto == 0) {
                    this.sinLeer = this.sinLeer + 1
                }
            });
        },
        unionArray(a1, a2) {
            let i1 = JSON.parse(JSON.stringify(a1))
            let i2 = JSON.parse(JSON.stringify(a2))
            return i1.concat(i2)
        },
        compare(a, b) {
            let fa = Date.parse(a.fecha)
            let fb = Date.parse(b.fecha)
            if (fa > fb) {
                return -1;
            }
            if (fa < fb) {
                return 1;
            }
            // a debe ser igual b
            return 0;
        },
        getNotificaciones() {
            fetch(this.$store.state.connection + 'notificacion_alumno/' + this.$store.state.session.id, {
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
                        this.noti = json
                        this.cantSinLeer(this.noti)
                        let n = this.unionArray(this.noti, state.notificaciones)
                        this.$store.state.notificaciones=n.sort(this.compare)
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