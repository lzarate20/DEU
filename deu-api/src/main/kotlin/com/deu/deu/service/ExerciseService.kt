package com.deu.deu.service

import com.deu.deu.dto.ExerciseDTO
import com.deu.deu.exception.NotFoundException
import com.deu.deu.model.Exercise
import com.deu.deu.model.Video
import com.deu.deu.repository.ExerciseRepository
import com.deu.deu.repository.VideoRepository
import org.springframework.data.repository.findByIdOrNull
import org.springframework.stereotype.Service

@Service
class ExerciseService(
    private val exerciseRepository: ExerciseRepository,
    private val videoRepository: VideoRepository
) {


    fun getExercises(): List<Exercise> {
        return exerciseRepository.findAll().toList()
    }

    fun getExercise(id: Int): Exercise? {
        return exerciseRepository.findByIdOrNull(id)
    }

    fun persist(exerciseDTO: ExerciseDTO): Exercise {
        val video = exerciseDTO.idVideo?.let { videoRepository.findByIdOrNull(exerciseDTO.idVideo) }
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
        val exerciseId = exerciseDTO.id.let(String::toInt)
        val exercise =
            exerciseRepository.findByIdOrNull(exerciseId) ?: throw NotFoundException("No se encontró el ejercicio")
        val video: Video = exerciseDTO.idVideo?.let { videoRepository.findByIdOrNull(exerciseDTO.idVideo) }
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