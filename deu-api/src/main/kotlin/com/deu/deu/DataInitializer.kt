package com.deu.deu

import com.deu.deu.model.*
import com.deu.deu.repository.*
import org.springframework.boot.CommandLineRunner
import org.springframework.context.annotation.Bean
import org.springframework.stereotype.Component
import java.util.*

@Component
class DataInitializer(
    val userRepository: UserRepository,
    val teamRepository: TeamRepository,
    val exerciseRepository: ExerciseRepository,
    val videoRepository: VideoRepository,
    val trainingRepository: TrainingRepository,
    val commentRepository: CommentRepository,
    val configRepository: ConfigRepository
) {

    @Bean
    fun initData(): CommandLineRunner {
        return CommandLineRunner {
            // Crear Usuarios
            val trainer = User(name = "John Trainer", email = "john.trainer@example.com", password = "1234", type = UserType.TRAINER)
            val trainee = User(name = "Jane Trainee", email = "jane.trainee@example.com", password = "1234", type = UserType.TRAINEE, position = Position.FORWARD)

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
                date = Date(),
                type = TrainingType.STRENGTH,
                comments = listOf()  // Sin comentarios al principio
            )
            trainingRepository.save(training)

            // Crear un comentario
            val comment = Comment(idUser = trainee, comment = "Great workout!")
            commentRepository.save(comment)

            // Agregar el comentario al entrenamiento
            val updatedTraining = training.copy(comments = listOf(comment))
            trainingRepository.save(updatedTraining)

            // Crear una configuración de tema para el usuario
            val config = Config(idUser = trainer, theme = ThemeType.DAY)
            configRepository.save(config)
        }
    }
}