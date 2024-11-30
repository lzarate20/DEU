<template>
     <h5 role="presentation" tabindex="0">Crear notificación</h5>
    <br>
    <div class="container">
        <div class="row  justify-content-center  ">
            <div class="col-md   ">
                <table class="table table-striped" aria-label="Alumnos">
                    <thead>
                        <tr>
                            <th scope="col"><input type="checkbox" id="todos" name="todos" v-model="todos" aria-label="Seleccionar todos los alumnos"></th>
                            <th scope="col">Nombre</th>
                            <th scope="col">Apellido</th>
                            <th scope="col">Posición</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr v-for="(alu, index) in listAlumnos" :key="index">
                            <th scope="row"><input type="checkbox" :id="alu.id" :value="alu.id" name="alumnos"
                                    :checked="todos" :aria-label="'Seleccionar '+ alu.nombre +' '+ alu.apellido"></th>
                            <td>{{ alu.nombre }}</td>
                            <td>{{ alu.apellido }}</td>
                            <td>{{ pos(alu.posicion) }}</td>
                        </tr>
                    </tbody>
                </table>
            </div>
            <div class="col-md  ">
                <label for="desc">Contenido:</label><br>
    <textarea id="desc" name="desc" style="width: 80%;resize: none;" rows="3" v-model="ent.contenido"> </textarea>

            </div>
        </div>
    </div>
    
    <div class="error" v-if="error"> {{ this.error }}</div>
    <button class="btn boton" @click="guardar()">Guardar</button>
</template>
<script>
export default {
    name: 'CrearNotificacion',
    created() {
        if (this.$store.state.session == null) {

            this.$router.replace("home");
        }
    },
    data() {
        return {
            error: null,
            listAlumnos: [],
            todos: false,
            ent: {
                contenido: "",
                entrenador: this.$store.state.session.id,
                alumnos: []
            },
        };

    },
    methods: {
        pos(p) {
            let posicion = ["Defensa", "Medio campo", "Ataque"]
            return posicion[p]
        },
        check(nombre) {
            let c = []
            let all = document.getElementsByName(nombre)
            all.forEach(e => {
                if (e.checked) {
                    c.push(parseInt(e.value))
                }
            });
            return c
        },
        guardar() {
            this.ent.alumnos=this.check("alumnos")
            fetch(this.$store.state.connection + 'notificacion', {
                method: 'POST',
                headers: {
                    'Accept': 'application/json',
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(this.ent)
            })
                .then(response => {
                    return response.json();
                })
                .then(json => {
                    if (json.error) {
                        this.error = json.error
                    } else {
                        this.error = "Notificación enviada con éxito"

                    }
                })
                .catch(error => {
                    console.log(error)
                })
        },
        iniciar() {
            //usuario/alumnos
            fetch(this.$store.state.connection + 'usuario/alumnos/' + this.$store.state.session.id, {
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
    },
    mounted() {

        this.iniciar()
    },
}

</script>