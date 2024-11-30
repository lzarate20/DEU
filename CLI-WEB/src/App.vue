<template>
  <Navbar v-if="fun_ini"></Navbar>
  <div class="contenedor" v-if="this.$store.state.session != null ">
    <Links></Links>
    <div id="body" name="body" class="body">
      <router-view />
    </div>
  </div>
  <div id="body" v-if="this.$store.state.session == null " name="body"><router-view />
  </div>

  <loading v-model:active="isLoading" :can-cancel="false" :is-full-page="true" />
  <Footer></Footer>
</template>

<style>
@import './assets/style.css';
</style>
<script>
import Loading from 'vue-loading-overlay';
import 'vue-loading-overlay/dist/css/index.css';
import Navbar from '@/components/nav/navbar.vue'
import Footer from '@/components/nav/footer.vue'
import Links from '@/components/nav/links.vue'

import { state, socket } from "@/socket.js";
export default {
  computed: {
    connected() {
      return state.connected;
    }
  },
  async created() {
    this.$store.commit('SET_CONNECTION');
  },
  data() {
    return {
      isLoading: false,
      modo: 1,
      fuente: 1,
      id_config: 1,
      fun_ini: false,
    }
  },
  components: {
    Loading,
    Navbar,
    Footer,
    Links
  },

  methods: {


    inicio() {
      this.isLoading = true
      this.$store.state.session = JSON.parse(localStorage.getItem('sesion'))

      let modo = localStorage.getItem("modo")
      this.$store.state.modo = modo
      let fuente = localStorage.getItem("fuente")
      if (fuente) this.fuente = fuente
      body.style.fontSize = this.fuente + "rem"

      if (this.$store.state.session != null) {
        this.getConfig()
        if (this.$store.state.session.tipo == 0) {
          this.entrenador = true
        }
      } else {
        this.color(modo)
      }
      this.fun_ini = true
      this.isLoading = false
    },
    color(modo) {
      if (modo == 0 || modo == null || modo == undefined) {
        document.documentElement.style.setProperty('--background', "#000");
        document.documentElement.style.setProperty('--text_nav', "#fff");
        document.documentElement.style.setProperty('--nav', "#333");
        document.documentElement.style.setProperty('--text', "#fff");
      } else {
        document.documentElement.style.setProperty('--background', "#fff");
        document.documentElement.style.setProperty('--text_nav', "#000a");
        document.documentElement.style.setProperty('--nav', "#d9d9d9");
        document.documentElement.style.setProperty('--text', "#000");
      }
    },
    getConfig() {
      fetch(this.$store.state.connection + "configByUser/" + this.$store.state.session.id)
        .then(response => {
          return response.json();
        })
        .then(json => {
          if (json.error == null) {
            localStorage.setItem("modo", json.tema)
            this.$store.state.modo = json.tema
            this.$store.state.id_config = json.id
            this.color(json.tema)
          } else {
            console.log(json.error)
          }
        })
        .catch(error => {
          console.log(error)
        })
    }
  },
  mounted() {
    this.inicio()
    let user = this.$store.state.session
    if (user !== null) {
      socket.emit('coneccion', user.id)
    }

  },


}
</script>
