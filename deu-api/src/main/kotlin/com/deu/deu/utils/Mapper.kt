package com.deu.deu.utils

import com.deu.deu.dto.*
import com.deu.deu.model.*

fun User.toDTO(): UserDTOResponse {
    return UserDTOResponse(
        id = this.id,
        name = this.name,
        email = this.email,
        type = this.type,
        position = this.position,
        teams = this.teams.map{ it.toTeamUserDTO() }
    )
}

fun Team.toDTO(): TeamDTOResponse {
    return TeamDTOResponse(
        id = this.id,
        name = this.name,
        users = this.users.map { it.toDTO() }
    )
}

fun Team.toTeamUserDTO(): TeamUserDTOResponse {
    return TeamUserDTOResponse(
        id = this.id,
        name = this.name
    )
}

fun Training.toTrainingDTOResponse(): TrainingDTOResponse {
    return TrainingDTOResponse(
        this.id.toString(),
        this.name,
        this.description,
        this.trainer.ToTrainerDTO(),
        this.date,
        this.type,
        this.exercises.map { it -> it.toExerciseDto() },
        this.comments.map { it -> it.toCommentDTO()},
        this.trainees.map {it -> it.id}
    )
}

fun Exercise.toExerciseDto(): ExerciseDTO{
    return ExerciseDTO(
        this.id.toString(),
        this.name,
        this.description,
        this.time,
        this.units,
        this.count,
        this.type,
        this.category,
        this.video.id,
        this.video.url,
        this.isVisible
    )
}

fun User.ToTrainerDTO():TrainerDTO{
    return TrainerDTO(this.id)
}

fun Config.toDTO(): ConfigDTO {
    return ConfigDTO(
        id = this.id,
        idUser = this.user.id,
        theme = this.theme,
        letterSize = this.letterSize)
}

fun Comment.toCommentDTO(): CommentDTO{
    return CommentDTO(
        user = this.idUser.toDTO(),
        comment = this.comment,
    )
}