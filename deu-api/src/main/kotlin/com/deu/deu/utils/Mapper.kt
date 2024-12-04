package com.deu.deu.utils

import com.deu.deu.dto.*
import com.deu.deu.model.Config
import com.deu.deu.model.Team
import com.deu.deu.model.User

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

fun Config.toDTO(): ConfigDTO {
    return ConfigDTO(
        id = this.id,
        idUser = this.user.id,
        theme = this.theme)
}