package com.deu.deu.dto

import com.deu.deu.model.*
import com.fasterxml.jackson.annotation.JsonInclude
import java.time.LocalDate
import java.time.LocalDateTime

data class UserDTO(
    val name: String,
    val email: String,
    val password: String,
    val type: UserType,
    val position: Position?
)

data class TrainerDTO(
    val id: Int
)

@JsonInclude(JsonInclude.Include.NON_NULL)
data class UserDTOResponse(
    val id: Int,
    val name: String,
    val email: String,
    val type: UserType,
    val position: Position?,
    val teams: List<TeamUserDTOResponse>?
)

@JsonInclude(JsonInclude.Include.NON_NULL)
data class TeamUserDTOResponse(
    val id: Int,
    val name: String
)

@JsonInclude(JsonInclude.Include.NON_NULL)
data class TeamDTOResponse(
    val id: Int,
    val name: String,
    val users: List<UserDTOResponse>?
)

data class LoginDTO(
    val email: String,
    val password: String
)

data class UserLoginResponse(
    val token: String,
    val expirationDate: LocalDateTime,
    val user: UserDTOResponse
)

data class NotificationDTO(
    val message: String,
    val context: NotificationContext
)

data class ExerciseTrainingSaveDTO(
    val id: String? = null,
    val exercise: ExerciseDTO? = null
)

data class ExerciseDTO(
    val id: String?,
    val name: String,
    val description: String,
    val time: Int?,
    val units: UnitsType?,
    val count: Int,
    val type: TimeType,
    val category: ExerciseType,
    val idVideo: Int? = null,
    val url: String? = null,
    val isVisible: Boolean
)

data class TrainingDTO(
    val id: String?,
    val name: String,
    val description: String?,
    val trainer: TrainerDTO,
    val date: LocalDate,
    val trainingType: TrainingType,
    val exercises: List<ExerciseTrainingSaveDTO> = listOf(),
)

data class TrainingDTOResponse(
    val id: String?,
    val name: String,
    val description: String?,
    val trainer: TrainerDTO,
    val date: LocalDate,
    val trainingType: TrainingType,
    val exercises: List<ExerciseDTO> = listOf(),
    val comments: List<CommentDTO> = listOf()
)

data class TrainingTeamDTO(
    val id: Int,
)

data class TeamDTO(
    val name: String
)

data class ConfigDTO(
    val id: Int,
    val idUser: Int,
    val theme: ThemeType,
    val letterSize: LetterSize
)

data class CommentRequest(
    val userId:String,
    val comment:String
)

data class CommentDTO(
    val user:UserDTOResponse,
    val comment:String
)