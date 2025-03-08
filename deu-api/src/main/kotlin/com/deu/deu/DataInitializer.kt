package com.deu.deu

import com.deu.deu.dto.TrainingTeamDTO
import com.deu.deu.model.*
import com.deu.deu.repository.*
import com.deu.deu.service.TeamService
import org.springframework.boot.CommandLineRunner
import org.springframework.context.annotation.Bean
import org.springframework.security.crypto.password.PasswordEncoder
import org.springframework.stereotype.Component
import java.time.LocalDate
import java.time.LocalDateTime
import java.time.ZoneOffset
import java.util.*

@Component
class DataInitializer(
    val userRepository: UserRepository,
    val teamRepository: TeamRepository,
    val exerciseRepository: ExerciseRepository,
    val videoRepository: VideoRepository,
    val trainingRepository: TrainingRepository,
    val commentRepository: CommentRepository,
    val configRepository: ConfigRepository,
    val passwordEncoder: PasswordEncoder
) {

    @Bean
    fun initData(notificationRepository: NotificationRepository, teamService: TeamService): CommandLineRunner {
        return CommandLineRunner {
            // Crear Usuarios
            val encodedPass = passwordEncoder.encode("1234")
            val trainer = User(
                name = "John Trainer",
                email = "john.trainer@example.com",
                password = encodedPass,
                type = UserType.TRAINER
            )
            val trainee = User(
                name = "Jane Trainee",
                email = "jane.trainee@example.com",
                password = encodedPass,
                type = UserType.TRAINEE,
                position = Position.FORWARD
            )

            userRepository.saveAll(listOf(trainer, trainee))

            // Crear un equipo
            val team = Team(name = "Fitness Team", users = listOf(trainer, trainee))
            teamRepository.save(team)

            // Crear un video de ejercicio
            val video = Video(name = "Warmup Video", url = "http://example.com/videos/warmup")
            videoRepository.save(video)

            // Crear un ejercicio
            val exercise = Exercise(
                name = "Push-ups",
                description = "Standard push-up exercise",
                time = 60,
                units = UnitsType.SEC,
                count = 10,
                type = TimeType.REPETITION,
                category = ExerciseType.TRAINING,
                video = video,
                isVisible = true
            )
            exerciseRepository.save(exercise)

            // Crear un entrenamiento
            val training = Training(
                name = "Morning Strength Training",
                description = "A strength training session for the morning.",
                trainer = trainer,
                date = Date.from(LocalDateTime.now().toInstant(ZoneOffset.ofHours(-3))),
                type = TrainingType.STRENGTH,
                exercises = listOf(exercise),
                comments = listOf()  // Sin comentarios al principio
            )
            //teamService.addTraining(1, TrainingTeamDTO(1))
            trainingRepository.save(training)

            // Crear un comentario
            val comment = Comment(idUser = trainee, comment = "Great workout!")
            val comment2 = Comment(idUser = trainee, comment = "Nice work!")
            commentRepository.save(comment)

            val notification = Notification(message = "Una notificacion", date = LocalDateTime.now(), viewed = false)
            notificationRepository.save(notification)
            val updatedTrainer = trainer.copy(trainings = listOf(training), notifcations = listOf(notification))
            userRepository.save(updatedTrainer)
            // Agregar el comentario al entrenamiento
            val updatedTraining = training.copy(comments = listOf(comment, comment2))
            trainingRepository.save(updatedTraining)

            // Crear una configuración de tema para el usuario
            val config = Config(user = trainer, theme = ThemeType.DAY, letterSize = LetterSize.SMALL)
            configRepository.save(config)
        }
    }
}