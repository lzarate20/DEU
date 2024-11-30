package com.deu.deu.controller

import com.deu.deu.dto.ExerciseDTO
import com.deu.deu.model.Exercise
import com.deu.deu.service.ExerciseService
import org.springframework.web.bind.annotation.*


@RestController
class ExerciseController(val exerciseService: ExerciseService) {

    @GetMapping("/exercises")
    fun getExercises(): List<Exercise> {
        return exerciseService.getExercises()
    }

    @GetMapping("/exercise/{id}")
    fun getExercise(@PathVariable("id") id: Int): Exercise {
        return exerciseService.getExercise(id)
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