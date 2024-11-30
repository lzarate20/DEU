package com.deu.deu.service

import com.deu.deu.dto.TeamDTO
import com.deu.deu.dto.TeamDTOResponse
import com.deu.deu.exception.NotFoundException
import com.deu.deu.exception.UserNotFoundException
import com.deu.deu.model.Team
import com.deu.deu.model.User
import com.deu.deu.repository.TeamRepository
import com.deu.deu.repository.UserRepository
import com.deu.deu.utils.toDTO
import org.springframework.stereotype.Service

@Service
class TeamService(val teamRepository: TeamRepository, val userRepository: UserRepository) {

    fun findAll(): List<TeamDTOResponse> {
        val teamDTO = teamRepository.findAll()
        return teamDTO.map(Team::toDTO)
    }

    fun findById(id: Int): Team {
        return teamRepository.findById(id).orElseThrow { NotFoundException("No se encontro el grupo") }
    }

    fun delete(id: Int) {
        val team = teamRepository.findById(id).orElseThrow { NotFoundException("No se encontro el grupo") }
        for (user in team.users) {
            this.removeTeam(user.id, team.id)
        }
    }

    private fun removeTeam(idUser: Int, idGroup: Int) {
        val user = userRepository.findById(idUser).orElseThrow { UserNotFoundException() }
        val teams = user.teams.filter { it.id != idGroup }
        userRepository.save(user.copy(teams = teams))
    }

    fun removeUser(id: Int, idUser: Int) {
        val team = teamRepository.findById(id).orElseThrow { NotFoundException("No se encontro el grupo") }
        team.users.filter { it.id != idUser }
        teamRepository.save(team)
    }

    fun persist(team: TeamDTO) {
        teamRepository.save(Team(name = team.name))
    }

    fun addUser(id: Int, user: User) {
        val team = teamRepository.findById(id).orElseThrow { NotFoundException("No se encontro el grupo") }
        teamRepository.save(team.copy(users = team.users + user))
    }
}