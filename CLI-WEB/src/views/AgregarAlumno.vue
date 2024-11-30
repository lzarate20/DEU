<template>
    <h4>Agregar alumno</h4>
    <br>
    {{ mensaje }}
    <br>
    <table class="table table-striped" aria-label="Agregar alumno">
        <thead>
            <tr>
                <th scope="col">Nombre</th>
                <th scope="col">Apellido</th>
                <th scope="col">Email</th>
                <th scope="col"></th>
            </tr>
        </thead>
        <tbody>
            <tr v-for="(alu, index) in listAlumnos" :key="index">
                <td>{{ alu.nombre }}</td>
                <td>{{ alu.apellido }}</td>
                <td>{{ alu.email }}</td>
                <td><button class="btn boton" @click="agregar(alu)"
                        :aria-label="'Agregar ' + alu.nombre + ' ' + alu.apellido + ' email:' + alu.email">Agregar</button></td>
            </tr>
        </tbody>
    </table>
</template>
<script>
export default {
    name: 'AgregarAlumno',
    created() {
        if (this.$store.state.session == null) {

            this.$router.replace("home");
        }
    },
    data() {
        return {
            listAlumnos: {},
            mensaje: ""
        }
    },
    methods: {
        agregar(alu) {
            this.mensaje = ""
            fetch(this.$store.state.connection + 'entrenador_alumno', {
                method: 'POST',
                headers: {
                    'Accept': 'application/json',
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({ alumno: alu.id, entrenador: this.$store.state.session.id })
            })
                .then(response => {
                    return response.json();
                })
                .then(json => {
                    if (json.error) {
                        this.mensaje = json.error
                    } else {
                        this.mensaje = "Alumno agregado"

                        const index = this.listAlumnos.indexOf(alu);
                        if (index > -1) { // only splice array when item is found
                            this.listAlumnos.splice(index, 1); // 2nd parameter means remove one item only
                        }
                    }
                })
                .catch(error => {
                    console.log(error)
                })
        }
    },
    mounted() {
        fetch(this.$store.state.connection + 'usuario/Alumnos/' + this.$store.state.session.id, {
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
                    this.listAlumnos = JSON.parse(JSON.stringify(json.Alumnos))
                }
            })
            .catch(error => {
                console.log(error)
            })
    },
}

</script>