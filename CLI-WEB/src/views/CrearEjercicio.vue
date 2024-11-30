<template>
    <h4 role="presentation" tabindex="0"><font-awesome-icon :icon="['fas', 'user-plus']" /> Crear ejercicio</h4>
    <br>
    <form @submit.prevent="registrar" id="form">

        <br>
        <label for="nombre">Nombre:</label>
        <input id="nombre" name="nombre" required v-model="eje.nombre" aria-label="Nombre" />
        <br>
        <label for="cat">Categoría: </label>
        <select id="cat" name="cat" v-model="eje.categoria">
            <option value="0">Calentamiento</option>
            <option value="1">Entrenamiento</option>
            <option value="2">Regenerativo</option>
        </select>
        <br>
        <label for="desc">Descripción:</label><br>
        <textarea id="desc" name="desc" style="width: 80%;resize: none;" rows="3"  v-model="eje.descripcion"> </textarea>
        <br>
        <label for="tipo">Tipo de repeticiones:</label>
        <select id="tipo" name="tipo" v-model="eje.tipo">
            <option value="0">Tiempo</option>
            <option value="1">Repeticiones</option>
        </select>
        <br>
        <div v-if="eje.tipo == 0">
            <label for="tiempo">Tiempo:</label>
            <input id="tiempo" name="tiempo" type="number" min="1" max="255" required v-model="eje.tiempo" />
            <br>
            <label for="uni">Unidad de tiempo:</label>
            <input id="uni" name="uni" required v-model="eje.tipo_tiempo" />
            <br>
        </div>
        <div v-if="eje.tipo == 1">
            <label for="rep">Repeticiones:</label>
            <input id="rep" name="rep" type="number" min="1" max="255"  required v-model="eje.repeticiones" />
            <br>
        </div>

        <label for="file-upload" >Seleccionar video
        </label>
        <input id="video" name="video" type="file"   />
        <br>
        <div class="error" v-if="error"> {{ this.error }}</div>
        <br>
        <button class="boton btn " type="submit" >Guardar</button>


    </form>
    <loading v-model:active="isLoading" :can-cancel="false" :is-full-page="true" />
    <br>
</template>
<script>


import Loading from 'vue-loading-overlay';
import 'vue-loading-overlay/dist/css/index.css';
export default {
    name: 'CrearEjercicio',

    created() {
        if (this.$store.state.session == null) {

            this.$router.replace("home");
        }
    },
    data() {
        return {
            isLoading: false,
            error: false,
            eje: {
                categoria: 0,
                descripcion: "",
                id: 1,
                nombre: "",
                repeticiones: 1,
                tiempo: 1,
                tipo: 0,
                tipo_tiempo: "",
                video: 0,
                publico: 1,
                entrenador: this.$store.state.session.id
            },
        }
    },
    components: {
        Loading
    },

    methods: {
        registrar() {
            this.isLoading = true
            console.log(this.eje.entrenador)
            let formData = new FormData();
            formData.append('video', document.getElementById("video").files[0]);
            console.log(formData)
            fetch(this.$store.state.connection + 'video', {
                method: 'POST',
                body: formData
            })
                .then(response => {
                    return response.json();
                })
                .then(json => {
                    if (json.error) {
                        this.error = json.error
                    } else {
                        this.eje.video = json.id
                        console.log(this.eje.video)
                        fetch(this.$store.state.connection + 'ejercicio', {
                            method: 'POST',
                            headers: {
                                'Accept': 'application/json',
                                'Content-Type': 'application/json'
                            },
                            body: JSON.stringify(this.eje)
                        })
                            .then(response => {
                                return response.json();
                            })
                            .then(json => {
                                if (json.error) {
                                    this.error = json.error
                                } else {
                                    this.error= "Ejercicio guardado correctamente"
                                }
                            })
                            .catch(error => {
                                console.log(error)
                            })
                    }
                })
                .catch(error => {
                    console.log(error)
                })
            this.isLoading = false

        }

    }
}
</script>