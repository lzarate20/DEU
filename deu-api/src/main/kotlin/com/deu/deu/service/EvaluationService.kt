package com.deu.deu.service

import com.deu.deu.dto.EvaluationDTO
import com.deu.deu.exception.InvalidEvaluationScore
import com.deu.deu.exception.InvalidTrainingDateException
import com.deu.deu.exception.NotFoundException
import com.deu.deu.exception.UserNotFoundException
import com.deu.deu.model.Evaluation
import com.deu.deu.model.User
import com.deu.deu.repository.EvaluationRepository
import org.apache.coyote.BadRequestException
import org.springframework.stereotype.Service
import java.time.LocalDate
import java.time.chrono.ChronoLocalDate

@Service
class EvaluationService(
    private val userService: UserService,
    private val trainingService: TrainingService,
    private val evaluationRepository: EvaluationRepository
) {


    fun addEvaluation(evaluationDTO: EvaluationDTO, user: User): EvaluationDTO {
        val targetUser = evaluationDTO.userId.let { userService.findUserById(it) } ?: throw UserNotFoundException()
        val training = trainingService.getTraining(evaluationDTO.trainingId) ?: throw NotFoundException()
        if (training.date.isAfter(ChronoLocalDate.from(LocalDate.now()))) {
            throw InvalidTrainingDateException("El entrenamiento todavía no se realizó")
        }
        if (evaluationDTO.score < 0 || evaluationDTO.score > 5) {
            throw InvalidEvaluationScore("El puntaje debe ser entre 0 y 5")
        }
        if(evaluationRepository.findByTrainingIdAndEvaluatorAndTargetUserId(training.id, user, targetUser.id) != null){
            throw BadRequestException("El usuario ya fue calificado")
        }
        val evaluation =
            Evaluation(evaluator = user, targetUser = targetUser, training = training, score = evaluationDTO.score)
        evaluationRepository.save(evaluation)
        return evaluationDTO
    }

    fun getMyEvaluation(trainingId: Int, user: User): Evaluation? {
        val training = trainingService.getTraining(trainingId) ?: throw NotFoundException()
        return evaluationRepository.findByTrainingIdAndTargetUserId(training.id, user.id)
    }

    fun getMyEvaluationToUser(trainingId: Int, user: User, target: User): Evaluation? {
        val training = trainingService.getTraining(trainingId) ?: throw NotFoundException()
        return evaluationRepository.findByTrainingIdAndEvaluatorAndTargetUserId(training.id, user, target.id)
    }

    fun getAverageEvaluation(trainingId: Int): EvaluationDTO {
        val training = trainingService.getTraining(trainingId) ?: throw NotFoundException()
        val targetUser = training.trainer
        val averageScore: Double =
            evaluationRepository.findAllByTrainingIdAndTargetUserId(training.id, targetUser.id)
                ?.map { it.score }
                ?.takeIf { it.isNotEmpty() }
                ?.average()
                ?: 0.0
        return EvaluationDTO(userId =  targetUser.id, trainingId = trainingId, score = averageScore)
    }
}