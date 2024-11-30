<template >
    <div class="container ent  ">
        <div class="row">
            <div class="col-10">
                    <p>Nombre y apellido: {{ alumno.nombre }} {{ alumno.apellido }}</p>
                    <p>Posición: {{ pos }}</p>
            </div>
            <div class="col-1 d-flex d-flex  align-items-center ml-auto">
                <font-awesome-icon :icon="['fas', 'chevron-right']" />
            </div>

        </div>
    </div>
</template>
<script>
export default {
    name: 'Alumno',
    data() {
        return {
            pos:null
        }
    },
    props: [
        "alumno"
    ],
    mounted(){
        let pos=["Defensa","Medio campo","Ataque"]
        this.pos=pos[this.alumno.posicion]
    }
}
</script>