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

            // Crear videos de ejercicios
            val video = Video(name = "Warmup Video", url = "https://videos.pexels.com/video-files/29160300/12594551_1920_1080_30fps.mp4")
            val video2 = Video(name = "Warmup Video 2", url = "https://videos.pexels.com/video-files/32469700/13847440_2560_1440_25fps.mp4")

            videoRepository.save(video)
            videoRepository.save(video2)

            // Crear ejercicios
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

            // Crear entrenamientos para hoy
            val today = LocalDate.now()
            val training = Training(
                name = "Morning Strength Training",
                description = "A strength training session for the morning.",
                trainer = trainer,
                date = today,
                type = TrainingType.STRENGTH,
                exercises = listOf(exercise, exercise2),
                comments = listOf()
            )
            val training2 = Training(
                name = "Morning Speed Training",
                description = "A speed training session for the morning.",
                trainer = trainer,
                date = today,
                type = TrainingType.SPEED,
                exercises = listOf(exercise),
                comments = listOf()
            )

            // Crear un entrenamiento para el día previo
            val trainingPrev = Training(
                name = "Yesterday Endurance Training",
                description = "An endurance training session created for the previous day.",
                trainer = trainer,
                date = today.minusDays(1),
                type = TrainingType.DRIBBLING,
                exercises = listOf(exercise),
                comments = listOf()
            )

            trainingRepository.saveAll(listOf(training, training2, trainingPrev))

            // Crear comentarios
            val comment = Comment(idUser = trainee, comment = "Great workout!")
            val comment2 = Comment(idUser = trainee, comment = "Nice work!")
            commentRepository.save(comment)
            commentRepository.save(comment2)

            // Crear notificación
            val notification = Notification(
                message = "Una notificacion",
                date = LocalDateTime.now(),
                viewed = false,
                context = NotificationContext("TRAINING", "1")
            )
            notificationRepository.save(notification)

            // Actualizar trainer con entrenamientos y notificaciones
            val updatedTrainer = trainer.copy(
                trainings = listOf(training, training2, trainingPrev),
                notifcations = listOf(notification)
            )
            userRepository.save(updatedTrainer)

            // Agregar comentarios al entrenamiento
            val updatedTraining = training.copy(comments = listOf(comment, comment2))
            trainingRepository.save(updatedTraining)

            // Crear configuración de tema para el usuario
            val config = Config(user = trainer, theme = ThemeType.DAY, letterSize = LetterSize.SMALL)
            configRepository.save(config)
        }
    }
}
