package com.deu.deu.controller

import com.deu.deu.dto.ExerciseDTO
import com.deu.deu.dto.TrainingDTO
import com.deu.deu.dto.TrainingDTOResponse
import com.deu.deu.exception.NotFoundException
import com.deu.deu.model.Training
import com.deu.deu.service.TrainingService
import com.deu.deu.utils.toTrainingDTOResponse
import org.springframework.format.annotation.DateTimeFormat
import org.springframework.web.bind.annotation.*
import java.time.LocalDate
import java.util.*

@RestController
class TrainingController(val trainingService: TrainingService) {

    @GetMapping("/trainings")
    fun getUserTrainings(@RequestParam("date") @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) date: LocalDate,@RequestParam("id") id: Int): List<TrainingDTOResponse> {
        return if (date != null && id != null) {
            trainingService.getUserTrainingsByDate(id, date).map{it->it.toTrainingDTOResponse()}
        } else {
            trainingService.getTrainings().map{it->it.toTrainingDTOResponse()}
        }
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

}