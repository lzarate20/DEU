<template>
    <h1>Editar Perfil</h1>
        <form id="form"  @submit.prevent="save">
        <p>Nombre:</p>
        <input v-model="user.nombre"/>
        <p>Apellido:</p>
        <input v-model="user.apellido"/>
        <p>Email:</p>
        <input v-model="user.email"/>
        <input @click="save" class="boton btn " type="submit" value="Guardar">

    </form>

</template>

<script>
export default {
    name:'Edit',
    data(){
        return{
            user:this.$store.state.session
        };

    },
    created() {
        if(this.$store.state.session==null){
            
           this.$router.replace("home");
        }
    },
    methods:{
        
        emitValue(){
            this.$emit('update:user',user)
        },       
        save(){
            fetch(this.$store.state.connection + 'usuario_editar', {
                method: 'POST',
                headers: {
                    'Accept': 'application/json',
                    'Content-Type': 'application/json',

                },
                body: JSON.stringify({ nombre: this.user.nombre,apellido: this.user.apellido,email:  this.user.email, contra: this.user.contra,id: this.user.id,posicion: this.user.posicion, tipo: this.user.tipo })
            })
                .then(response => {
                    
                    return response.json();
                })
                .then(json => {
                    if(json.error){
                        this.error= json.error
                    }else{
                        this.$store.state.session = json
                    }
                })
                .catch(error => {
                   console.log(error)
                })
        }
        
    }


}


</script>