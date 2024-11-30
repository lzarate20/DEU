<template>
    <h4>Ejercicios</h4>
    <div v-for="(eje, index) in ejercicios" :key="index"  class="d-flex justify-content-center">
        <div style="width: 60%;"><Ejercicio :eje="eje" ></Ejercicio> <br></div>
    </div>
</template>
<script>
import Ejercicio from '@/components/ejercicio.vue'
export default {
    name: 'ListadoEjercicios',
    data() {
        return {
            ejercicios:[]
    }
    },
    components:{
        Ejercicio
    },
    created() {
        if (this.$store.state.session == null) {

            this.$router.replace("home");
        }
    },
    mounted(){
    fetch(this.$store.state.connection + "ejercicio_by_entrenador/" + this.$store.state.session.id)
      .then(response => {
        return response.json();
      })
      .then(json => {
        if (json.error == null) {
          this.ejercicios = json.Ejercicios
          console.log(this.ejercicios)
        } else {
          console.log(json.error)
        }
      })
      .catch(error => {
        console.log(error)
      })
    }
}
</script> 