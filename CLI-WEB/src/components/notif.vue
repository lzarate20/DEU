<template >
  <div class="container">
    <div>
      <p>Notificaciones:</p>
      <hr>
      <ul>
        <div v-for="(n, index) in notificaciones" :key="index">
          <div>
            <Noti role="button" tabindex="0" v-bind:notificacion="n" @click="leer(n)" v-on:keyup.enter="leer(n)"></Noti>
          </div>
          <br>
        </div>
      </ul>
    </div>
  </div>
</template>
<script>
import Noti from './noti.vue'

export default {
  name: 'notif',
  
  props:[
    "notificaciones"
  ],
  methods: {
    leer(n) {
      if(this.$store.state.session.tipo==1){
      n.visto = 1;
      fetch(this.$store.state.connection + 'notificacion_leer', {
                method: 'POST',
                headers: {
                    'Accept': 'application/json',
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(n)
            })
        .then(response => {
          return response.json();
        })
        .then(json => {
          if (json.error == null) {
            n.visto = 1;
            this.$store.state.notificacion = n;
          } else {
            console.log(json.error)
          }
        })
        .catch(error => {
          console.log(error)
        })
      }
      if(this.$store.state.session.tipo==0){
        this.$store.state.notificacion = n;
      }

      setTimeout(()=>{let vista= document.getElementById(n.id)
      vista.focus()},200)
    }
  },

  components: {
    Noti
  },

}
$('input:checkbox').keypress(function(e){
    e.preventDefault();
    if((e.keyCode ? e.keyCode : e.which) == 13){
        $(this).trigger('click');
    }
});
</script>