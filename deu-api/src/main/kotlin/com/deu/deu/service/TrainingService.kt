package com.deu.deu.service

import com.deu.deu.dto.CommentRequest
import com.deu.deu.dto.ExerciseDTO
import com.deu.deu.dto.ExerciseTrainingSaveDTO
import com.deu.deu.dto.TrainingDTO
import com.deu.deu.exception.InvalidUserIdException
import com.deu.deu.exception.NotFoundException
import com.deu.deu.model.*
import com.deu.deu.repository.CommentRepository
import com.deu.deu.repository.NotificationRepository
import com.deu.deu.repository.TrainingRepository
import com.deu.deu.repository.UserRepository
import org.springframework.data.repository.findByIdOrNull
import org.springframework.stereotype.Service
import java.time.LocalDateTime

@Service
class TrainingService(
    val exerciseService: ExerciseService,
    val trainingRepository: TrainingRepository,
    val userRepository: UserRepository,
    val commentRepository: CommentRepository,
    val notificationRepository: NotificationRepository,
) {


    fun getTrainings(): List<Training> {
        return trainingRepository.findAll().toList()
    }

    fun getTraining(trainingId: Int): Training? {
        return trainingRepository.findByIdOrNull(trainingId)
    }

    fun saveTraining(trainingDTO: TrainingDTO): Training {
        val trainer = userRepository.findByIdOrNull(trainingDTO.trainer.id) ?: throw InvalidUserIdException()
        if (trainer.type != UserType.TRAINER) {
            throw InvalidUserIdException("El id no corresponde a un entrenador válido")
        }
        val exercises =
            trainingDTO.exercises.map { getExercise(it) }
        val training = Training(
            name = trainingDTO.name, description = trainingDTO.description, trainer = trainer,
            date = trainingDTO.date, type = trainingDTO.trainingType, exercises = exercises
        )
        trainingRepository.save(training)
        userRepository.save(trainer.copy(trainings = trainer.trainings.plus(training)))
        return training
    }

    private fun getExercise(dto: ExerciseTrainingSaveDTO): Exercise {
        return when {
            dto.id != null -> dto.id.toIntOrNull()?.let { exerciseService.getExercise(it) } ?: throw NotFoundException()
            dto.exercise != null -> exerciseService.persist(dto.exercise)
            else -> throw NotFoundException()
        }
    }

    fun addExercisesToTraining(trainingId: Int, exercisesDTO: List<ExerciseDTO>) {
        val training = trainingRepository.findByIdOrNull(trainingId)
            ?: throw NotFoundException("No se encontro el entrenamiento $trainingId")
        val exercises = exercisesDTO.map { ex ->
            ex.id?.let { exerciseService.getExercise(ex.id.toInt()) } ?: exerciseService.persist(ex)
        }
        trainingRepository.save(training.copy(exercises = training.exercises + exercises))
    }

    fun removeTraining(trainingId: Int) {
        trainingRepository.deleteById(trainingId)
    }

    fun addCommentToTraining(trainingId: Int, comment: CommentRequest): Training {
        val training = trainingRepository.findByIdOrNull(trainingId)
            ?: throw NotFoundException("No se encontro el entrenamiento $trainingId")
        val user = userRepository.findByIdOrNull(comment.userId.toInt())
            ?: throw NotFoundException("No se encontro el usuario ${comment.userId}")
        val comment = commentRepository.save(Comment(idUser = user, comment = comment.comment))
        val comments = training.comments
        val usersToNotify =
            userRepository.findAll().filter { it.id != comment.idUser.id }
                .filter { it.trainings.map(Training::id).contains(training.id) }
        val notification = notificationRepository.save(
            Notification(
                message = "Mensaje nuevo",
                date = LocalDateTime.now(),
                viewed = false,
                context = NotificationContext("TRAINING",trainingId.toString())
            )
        )
        usersToNotify.forEach { us -> userRepository.save(us.copy(notifcations = us.notifcations.plus(notification))) }
        return trainingRepository.save(training.copy(comments = comments.plus(comment)))
    }
}