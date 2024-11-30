<template>
    <h5>Crear entrenamiento</h5>
    <br>
    <label for="nombre">Nombre: </label>
    <input id="nombre" name="nombre" required v-model="ent.nombre" aria-label="Nombre" />
    <br>
    <label for="cat">Categoría: </label>
    <select id="cat" name="cat" v-model="ent.tipo">
        <option v-for="(t, index) in tipo" :key="index" :value="index">{{ t }}</option>
    </select>
    <br>
    <label for="fecha">Fecha:</label>
    <input id="fecha" type="datetime-local" name="fecha" required v-model="ent.fecha" />
    <br>
    <label for="desc">Descripción:</label><br>
    <textarea id="desc" name="desc" style="width: 80%;resize: none;" rows="3" v-model="ent.descripcion"> </textarea>

    <div class="container">
        <div class="row  justify-content-center  ">
            <div class="col-md   ">
                <h6>Alumnos:</h6>
                <table class="table table-striped" aria-label="Alumnos:">
                    <thead>
                        <tr>
                            <th scope="col"><input type="checkbox" id="todos" aria-label="Seleccionar todos los alumnos" name="todos" v-model="todos"></th>
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
                
                <h6>Ejercicios:</h6>
                <table class="table table-striped" aria-label="Ejercicios">
                    <thead>
                        <tr>
                            <th scope="col"><input type="checkbox" id="todos" name="todos" aria-label="Seleccionar todos los ejercicios" v-model="td"></th>
                            <th scope="col">Nombre</th>
                            <th scope="col">Categoría</th>
                            <th scope="col">Video</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr v-for="(e, index) in eje" :key="index">
                            <th scope="row"><input type="checkbox" :id="e.id" name="ejercicios" :aria-label="'Seleccionar '+e.nombre+' de la categoría '+cat[e.categoria]" :value="e.id" :checked="td">
                            </th>
                            <td>{{ e.nombre }}</td>
                            <td>{{ cat[e.categoria] }}</td>
                            <td><a :href="this.$store.state.connection + 'static/videos/' + e.video.nombre" target="_blank"
                                    rel="noopener noreferrer">Ver {{ e.nombre }}</a></td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
    <div class="error" v-if="error"> {{ this.error }}</div>
    <button class="btn boton" @click="guardar()">Guardar</button>
    
</template>

<script>
export default {
    name: 'CrearEntrenamiento',
    data() {
        return {
            error: null,
            listAlumnos: [],
            todos: false,
            eje: [],
            td: false,
            ent: {
                descripcion: "",
                entrenador: this.$store.state.session.id,
                fecha: "",
                id: 0,
                nombre: "",
                tipo: 0,
                eje: [],
                alu: []

            },
            cat: ["Calentamiento", "Entrenamiento", "Regenarativo"],
            tipo: ["Fuerza", "Velocidad", "Resistencia", "Estrategia"]
        };

    },
    created() {
        if (this.$store.state.session == null) {

            this.$router.push({ path: 'Home' })
        }
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
                    c.push(e.value)
                }
            });
            return c
        },
        guardar() {
            this.ent.eje=this.check("ejercicios")
            this.ent.alu=this.check("alumnos")
            fetch(this.$store.state.connection + 'entrenamiento', {
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
                        this.error = "Entrenamiento agregado con éxito"

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
            fetch(this.$store.state.connection + "ejercicio_by_entrenador/" + this.$store.state.session.id)
                .then(response => {
                    return response.json();
                })
                .then(json => {
                    if (json.error == null) {
                        this.eje = json.Ejercicios
                    } else {
                        console.log(json.error)
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