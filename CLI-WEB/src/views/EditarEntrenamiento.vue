<template>
</template>
<script>
export default {
    name:'EditarEntrenamiento',
    created() {
        if(this.$store.state.session==null){
            
           this.$router.replace("home");
        }
    },
    }
</script>