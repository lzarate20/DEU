package com.deu.deu.controller

import com.deu.deu.dto.ExerciseDTO
import com.deu.deu.exception.NotFoundException
import com.deu.deu.model.Exercise
import com.deu.deu.model.ExerciseType
import com.deu.deu.service.ExerciseService
import org.springframework.data.domain.Page
import org.springframework.web.bind.annotation.*


@RestController
@RequestMapping("/api")
class ExerciseController(val exerciseService: ExerciseService) {

    @GetMapping("/exercises/all")
    fun getExercises(): List<Exercise> {
        return exerciseService.getExercises()
    }

    @GetMapping("/exercises")
    fun getExercises(
        @RequestParam(defaultValue = "0") page: Int,
        @RequestParam(defaultValue = "10") size: Int,
        @RequestParam(required = false) name: String?,
        @RequestParam(required = false) category: ExerciseType?,
        @RequestParam(required = false) isVisible: Boolean?
    ): Page<Exercise> {
        return exerciseService.getExercises(page, size, name, category, isVisible)
    }

    @GetMapping("/exercise/{id}")
    fun getExercise(@PathVariable("id") id: Int): Exercise {
        return exerciseService.getExercise(id) ?: throw NotFoundException("No se encontro el ejercicio")
    }

    @PostMapping("/exercise")
    fun postExercise(@RequestBody exerciseDTO: ExerciseDTO):Exercise {
        return exerciseService.persist(exerciseDTO)
    }

    @PutMapping("/exercise")
    fun putExercise(@RequestBody exerciseDTO: ExerciseDTO):Exercise {
        return exerciseService.update(exerciseDTO)
    }

    @DeleteMapping("/exercise/{id}")
    fun deleteExercise(@PathVariable("id") id: Int) {
        return exerciseService.delete(id)
    }
}