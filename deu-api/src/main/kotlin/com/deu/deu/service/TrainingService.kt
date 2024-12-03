package com.deu.deu.service

import com.deu.deu.dto.TrainingDTO
import com.deu.deu.exception.InvalidUserIdException
import com.deu.deu.model.Training
import com.deu.deu.model.UserType
import com.deu.deu.repository.ExerciseRepository
import com.deu.deu.repository.TrainingRepository
import com.deu.deu.repository.UserRepository
import org.springframework.data.repository.findByIdOrNull
import org.springframework.stereotype.Service

@Service
class TrainingService(
    val exerciseRepository: ExerciseRepository,
    val exerciseService: ExerciseService,
    val trainingRepository: TrainingRepository,
    val userRepository: UserRepository
) {


    fun getTrainings(): List<Training> {
        return trainingRepository.findAll().toList()
    }

    fun getTraining(trainingId: Int): Training? {
        return trainingRepository.findByIdOrNull(trainingId)
    }

    fun saveTraining(trainingDTO: TrainingDTO) {
        val trainer = userRepository.findByIdOrNull(trainingDTO.trainer.id) ?: throw InvalidUserIdException()
        if (trainer.type != UserType.TRAINER) {
            throw InvalidUserIdException("El id no corresponde a un entrenador válido")
        }
        val exercises =
            trainingDTO.exercises.map { exerciseService.getExercise(it.id.toInt()) ?: exerciseService.persist(it) }
        val training = Training(
            name = trainingDTO.name, description = trainingDTO.description, trainer = trainer,
            date = trainingDTO.date, type = trainingDTO.trainingType, exercises = exercises
        )
        trainingRepository.save(training)
    }
}