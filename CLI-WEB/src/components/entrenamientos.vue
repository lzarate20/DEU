<template >
  <div class="container">
    <div>
      <p tabindex="0" role="presentation">Entrenamientos:</p>
      <hr>
      <ul>
        <div v-if="entrenamientos.length == 0" tabindex="0" role="presentation">No hay entrenamientos</div>
        <div v-for="(ent, index) in entrenamientos" :key="index">
          <div>
            <Ent role="button" tabindex="0" :entrenamiento="ent" @click="click(ent)" v-on:keyup.enter="click(ent)"></Ent>
          </div>
          <br>
        </div>
      </ul>
    </div>
  </div>

  <Carga :cargando="isLoading"></Carga>
</template>
<script>
import Carga from '@/components/carga.vue'
import Ent from './ent.vue'
export default {
  name: 'Entrenamientos',
  data() {
    return {
      isLoading: false,
      entrenamientos: []
    }
  },
  components: {
    Carga,
    Ent
  },
  methods: {
    compare(a, b) {
      let fa = Date.parse(a.fecha)
      let fb = Date.parse(b.fecha)
      if (this.$route.path != '/historial_entrenamientos') {
        if (fa < fb) {
          return -1;
        }
        if (fa > fb) {
          return 1;
        }
        // a debe ser igual b
        return 0;
      }
      else {
        if (fa > fb) {
        return -1;
      }
      if (fa < fb) {
        return 1;
      }
      // a debe ser igual b
      return 0;         
      }

    },
    short(list) {
      return list.sort(this.compare)
    },
    delete(list) {
      let lista = []
      let ayer = (new Date())
      list.forEach(e => {
        let f = Date.parse(e.fecha)
        if (ayer < f && this.$route.path != '/historial_entrenamientos') {
          lista.push(e)
        }
        if (ayer > f && this.$route.path == '/historial_entrenamientos') {
          lista.push(e)
        }

      });

      return lista
    },
    click(ent) {
      this.$store.state.entrenamiento = ent
      setTimeout(() => {
        let vista = document.getElementById(ent.id)
        vista.focus()
      }, 200)


    }
  },
  mounted() {
    let tipo = ["entrenador", "alumno"]
    fetch(this.$store.state.connection + "entrenamiento_by_" + tipo[this.$store.state.session.tipo] + "/" + this.$store.state.session.id)
      .then(response => {
        return response.json();
      })
      .then(json => {
        if (json.error == null) {
          this.entrenamientos = this.delete(this.short(json.Entrenamientos))
          this.$store.state.entrenamiento = this.entrenamientos[0]
        } else {
          console.log(json.error)
        }
      })
      .catch(error => {
        console.log(error)
      })

  },
  updated() {
    this.isLoading = false
  },

}
</script> 