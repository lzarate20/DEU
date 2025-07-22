package com.deu.deu

import com.deu.deu.dto.TrainingTeamDTO
import com.deu.deu.model.*
import com.deu.deu.repository.*
import com.deu.deu.service.TeamService
import org.springframework.boot.CommandLineRunner
import org.springframework.context.annotation.Bean
import org.springframework.security.crypto.password.PasswordEncoder
import org.springframework.stereotype.Component
import java.time.*
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
            val video = Video(name = "Warmup Video", url = "https://www.youtube.com/embed/ZFEIxGNErd4")
            val video2 = Video(name = "Warmup Video", url = "https://www.youtube.com/embed/gu0GGcG1Ux4")

            videoRepository.save(video)
            videoRepository.save(video2)

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
            val exercise2 = Exercise(
                name = "Push-ups 2",
                description = "Standard push-up exercise",
                time = 60,
                units = UnitsType.SEC,
                count = 10,
                type = TimeType.REPETITION,
                category = ExerciseType.TRAINING,
                video = video2,
                isVisible = true
            )
            exerciseRepository.save(exercise)
            exerciseRepository.save(exercise2)

            // Crear un entrenamiento
            val training = Training(
                name = "Morning Strength Training",
                description = "A strength training session for the morning.",
                trainer = trainer,
                date = LocalDate.from(Instant.now().atZone(ZoneId.systemDefault()).toLocalDate()),
                type = TrainingType.STRENGTH,
                exercises = listOf(exercise,exercise2),
                comments = listOf()
            )
            val training2 = Training(
                name = "Morning Strength Training 2",
                description = "A speed training session for the morning.",
                trainer = trainer,
                date = LocalDate.from(Instant.now().atZone(ZoneId.systemDefault()).toLocalDate()),
                type = TrainingType.SPEED,
                exercises = listOf(exercise),
                comments = listOf()
            )
            trainingRepository.saveAll(listOf(training,training2))

            // Crear un comentario
            val comment = Comment(idUser = trainee, comment = "Great workout!")
            val comment2 = Comment(idUser = trainee, comment = "Nice work!")
            commentRepository.save(comment)

            val notification = Notification(message = "Una notificacion", date = LocalDateTime.now(), viewed = false)
            notificationRepository.save(notification)
            val updatedTrainer = trainer.copy(trainings = listOf(training,training2), notifcations = listOf(notification))
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