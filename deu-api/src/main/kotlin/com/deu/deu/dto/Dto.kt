package com.deu.deu.dto

import com.deu.deu.model.*
import com.fasterxml.jackson.annotation.JsonInclude
import java.util.*

data class UserDTO(
    val name: String,
    val email: String,
    val password: String,
    val type: UserType,
    val position: Position?
)

data class TrainerRequestDTO(
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
    val token:String,
    val user: UserDTOResponse
)

data class ExerciseDTO(
    val id: String,
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
    val trainer: TrainerRequestDTO,
    val date: Date,
    val trainingType: TrainingType,
    val exercises: List<ExerciseDTO> = listOf(),
)

data class TeamDTO(
    val name: String
)

data class ConfigDTO(
    val id: Int,
    val idUser: Int,
    val theme: ThemeType
)