<template>
    <div class="contenedor_c ">
        <div class="row u justify-content-center  ">
            <div class="col-md order-md-2 hijo  justify-content-center   ">
                <div>
                <Entrenamiento v-if="this.$store.state.session != null ">
                </Entrenamiento>
            </div>
            </div>
            <div class="col-md order-md-1  hijo   justify-content-center  ">
                <div>
                <Entrenamientos v-if="this.$store.state.session != null"></Entrenamientos>
            </div>
            </div>
        </div>
    </div>
</template>
<script>
import Entrenamientos from '@/components/entrenamientos.vue'
import Entrenamiento from '@/components/entrenamiento.vue'
export default {
    name:'HistorialEntrenamiento',
    created() {
        if(this.$store.state.session==null){
            
           this.$router.replace("home");
        }
    },
    components: {
        Entrenamientos,
        Entrenamiento,
    },
    }
</script> 