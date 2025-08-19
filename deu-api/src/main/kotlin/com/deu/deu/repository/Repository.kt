package com.deu.deu.repository

import com.deu.deu.model.*
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.JpaSpecificationExecutor
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.CrudRepository



interface UserRepository : CrudRepository<User, Int> {
    fun findByEmail(email: String): User?

    @Query("SELECT CASE WHEN COUNT(t) > 0 THEN true ELSE false END FROM User u JOIN u.trainings t WHERE u.id = :userId AND t.id = :trainingId")
    fun existsTrainingForUser(userId: Int, trainingId: Int): Boolean
}

interface ExerciseRepository : JpaRepository<Exercise, Int>, JpaSpecificationExecutor<Exercise>
interface VideoRepository : CrudRepository<Video, Int>
interface TrainingRepository : CrudRepository<Training, Int>

interface CommentRepository : CrudRepository<Comment, Int>
interface ConfigRepository : CrudRepository<Config, Int> {
    fun findByUserId(userId: Int): Config?
}

interface TeamRepository : CrudRepository<Team, Int>
interface NotificationRepository : CrudRepository<Notification, Int>
interface EvaluationRepository : CrudRepository<Evaluation, Int>{
    fun findByTrainingIdAndTargetUserId(trainingId: Int, targetUserId: Int): Evaluation?
    fun findAllByTrainingIdAndTargetUserId(trainingId: Int, targetUserId: Int): List<Evaluation>?
    fun findByTrainingIdAndEvaluatorAndTargetUserId(trainingId: Int, evaluator: User, targetUserId: Int): Evaluation?
}