import { createRouter, createWebHistory } from 'vue-router'
import Home from '../views/Home.vue'
import EditProfile from '../views/EditProfile.vue'
import CrearEntrenamiento from '../views/CrearEntrenamiento.vue'
import EditarEntrenamiento from '../views/EditarEntrenamiento.vue'
import HistorialEntrenamiento from '../views/HistorialEntrenamientos.vue'
import AgregarAlumno from '../views/AgregarAlumno.vue'
import ListadoAlumnos from '../views/ListadoAlumnos.vue'
import CrearNotificacion from '../views/CrearNotificacion.vue'
import ListadoNotificaciones from '../views/ListadoNotificaciones.vue'
import ListadoEjercicios from '../views/ListadoEjercicios.vue'
import CrearEjercicio from '../views/CrearEjercicio.vue'
import Notificaciones from '../views/Notificaciones.vue'


const routes = [
  {
    path: '/',
    name: 'Home',
    component: Home
  },
  {
    path: '/:pathMatch(.*)*',
    name:"Error",
    redirect:"/"
  },
  {
    path: '/edit-profile',
    name: 'Edit',
    component: EditProfile
  },
  {
    path: '/crear_entrenamiento',
    name: 'CrearEntrenamiento',
    component: CrearEntrenamiento
  },
  {
    path: '/editar_entrenamiento/:id',
    name: 'EditarEntrenamiento',
    component: EditarEntrenamiento
  },
  {
    path: '/historial_entrenamientos',
    name: 'HistorialEntrenamiento',
    component: HistorialEntrenamiento
  },
  {
    path: '/agregar_alumno',
    name: 'AgregarAlumno',
    component: AgregarAlumno
  },
  {
    path: '/listado_alumnos',
    name: 'ListadoAlumnos',
    component: ListadoAlumnos
  },
  {
    path: '/crear_notificacion',
    name: 'CrearNotificacion',
    component: CrearNotificacion
  },
  {
    path: '/listado_notificaciones',
    name: 'ListadoNotificaciones',
    component: ListadoNotificaciones
  },
  {
    path: '/notificaciones',
    name: 'Notificaciones',
    component: Notificaciones
  },
  {
    path: '/crear_ejercicio',
    name: 'CrearEjercicio',
    component: CrearEjercicio
  },
  {
    path: '/listado_ejercicios',
    name: 'ListadoEjercicios',
    component: ListadoEjercicios
  },
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

export default router
