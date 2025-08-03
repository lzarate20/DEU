package com.deu.deu.controller

import com.deu.deu.dto.ExerciseDTO
import com.deu.deu.dto.TrainingDTO
import com.deu.deu.dto.TrainingDTOResponse
import com.deu.deu.exception.NotFoundException
import com.deu.deu.model.Training
import com.deu.deu.service.TrainingService
import com.deu.deu.service.UserService
import com.deu.deu.utils.toTrainingDTOResponse
import org.springframework.web.bind.annotation.*

@RestController
class TrainingController(
    val trainingService: TrainingService,
    private val userService: UserService
) {

    @GetMapping("/trainings")
    fun getUserTrainings(): List<TrainingDTOResponse> {
        return trainingService.getTrainings().map { it -> it.toTrainingDTOResponse() }
    }

    @GetMapping("/training/{id}")
    fun getTraining(@PathVariable("id") id: Int): Training {
        return trainingService.getTraining(id) ?: throw NotFoundException("No se encontro el entrenamiento $id")
    }

    @PostMapping("/training")
    fun postTraining(@RequestBody trainingDTO: TrainingDTO) {
        trainingService.saveTraining(trainingDTO)
    }

    @PatchMapping("/training/{id}")
    fun postTraining(@PathVariable("id") id: Int, @RequestBody exercises: List<ExerciseDTO>) {
        trainingService.addExercisesToTraining(id, exercises)
    }

    @DeleteMapping("/training/{id}")
    fun postTraining(@PathVariable("id") id: Int) {
        userService.removeTraining(id)
        trainingService.removeTraining(id)
    }

}