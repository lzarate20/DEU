package com.deu.deu.service

import com.deu.deu.dto.ExerciseDTO
import com.deu.deu.exception.MissingParamException
import com.deu.deu.exception.NotFoundException
import com.deu.deu.model.Exercise
import com.deu.deu.model.Video
import com.deu.deu.repository.ExerciseRepository
import com.deu.deu.repository.VideoRepository
import org.springframework.stereotype.Service

@Service
class ExerciseService(
    private val exerciseRepository: ExerciseRepository,
    private val videoRepository: VideoRepository
) {


    fun getExercises(): List<Exercise> {
        return exerciseRepository.findAll()
    }

    fun getExercise(id: Int): Exercise {
        return exerciseRepository.findById(id).orElseThrow { NotFoundException("No se encontro el ejercicio") }
    }

    fun persist(exerciseDTO: ExerciseDTO): Exercise {
        val video = exerciseDTO.idVideo?.let { videoRepository.findById(exerciseDTO.idVideo).orElse(null) }
            ?: exerciseDTO.url?.let {
                Video(
                    name = exerciseDTO.name,
                    url = exerciseDTO.url
                )
            } ?: throw NotFoundException("No se encontro el video")
        val exercise = Exercise(
            name = exerciseDTO.name,
            description = exerciseDTO.description,
            time = exerciseDTO.time,
            units = exerciseDTO.units,
            count = exerciseDTO.count,
            type = exerciseDTO.type,
            category = exerciseDTO.category,
            video = video,
            isVisible = exerciseDTO.isVisible
        )
        videoRepository.save(video)
        exerciseRepository.save(exercise)
        return exercise
    }

    fun update(exerciseDTO: ExerciseDTO): Exercise {
        val exerciseId =
            exerciseDTO.id?.let(String::toInt) ?: throw MissingParamException("Se requiere un id de ejercicio")
        val exercise =
            exerciseRepository.findById(exerciseId).orElseThrow { NotFoundException("No se encontró el ejercicio") }
        val video = exerciseDTO.idVideo?.let { videoRepository.findById(exerciseDTO.idVideo).orElse(null) }
            ?: exerciseDTO.url?.let {
                Video(
                    name = exerciseDTO.name,
                    url = exerciseDTO.url
                )
            } ?: throw NotFoundException("No se encontro el video")
        val updateExcercise = exercise.copy(
            name = exerciseDTO.name,
            description = exerciseDTO.description,
            time = exerciseDTO.time,
            units = exerciseDTO.units,
            count = exerciseDTO.count,
            type = exerciseDTO.type,
            category = exerciseDTO.category,
            isVisible = exerciseDTO.isVisible
        )
        if (video.url != exercise.video.url) {
            val updateExcercise = updateExcercise.copy(video = video)
            videoRepository.save(video)
            exerciseRepository.save(updateExcercise)
        }
        exerciseRepository.save(updateExcercise)
        return exercise
    }

    fun delete(id: Int) {
        exerciseRepository.deleteById(id)
    }

}