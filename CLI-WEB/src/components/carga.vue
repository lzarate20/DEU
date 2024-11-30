<template>
    <div class="carga" v-if="cargando" aria-label="Cargando" aria-busy="false">
        <div class="signo">
            <div class="centro"></div>
            <div class="marca"></div>
        </div>
    </div>
</template>
<script>
export default {
    name:"Carga",
    props:[
        "cargando"
    ]
}
</script>