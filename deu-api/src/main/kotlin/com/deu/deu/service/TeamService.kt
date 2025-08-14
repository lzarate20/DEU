package com.deu.deu.service

import com.deu.deu.dto.NotificationDTO
import com.deu.deu.dto.TeamDTO
import com.deu.deu.dto.TeamDTOResponse
import com.deu.deu.dto.TrainingTeamDTO
import com.deu.deu.exception.NotFoundException
import com.deu.deu.exception.UserNotFoundException
import com.deu.deu.model.Team
import com.deu.deu.model.User
import com.deu.deu.repository.TeamRepository
import com.deu.deu.repository.UserRepository
import com.deu.deu.utils.toDTO
import org.springframework.data.repository.findByIdOrNull
import org.springframework.stereotype.Service

@Service
class TeamService(
    val teamRepository: TeamRepository,
    val userRepository: UserRepository,
    private val userService: UserService
) {

    fun findAll(): List<TeamDTOResponse> {
        val teamDTO = teamRepository.findAll()
        return teamDTO.map(Team::toDTO)
    }

    fun findById(id: Int): Team {
        return teamRepository.findByIdOrNull(id) ?: throw NotFoundException("No se encontro el grupo")
    }

    fun delete(id: Int) {
        val team = teamRepository.findByIdOrNull(id) ?: throw NotFoundException("No se encontro el grupo")
        for (user in team.users) {
            this.removeTeam(user.id, team.id)
        }
    }

    private fun removeTeam(idUser: Int, idGroup: Int) {
        val user = userRepository.findByIdOrNull(idUser) ?: throw UserNotFoundException()
        val teams = user.teams.filter { it.id != idGroup }
        userRepository.save(user.copy(teams = teams))
    }

    fun removeUser(id: Int, idUser: Int) {
        val team = teamRepository.findByIdOrNull(id) ?: throw NotFoundException("No se encontro el grupo")
        team.users.filter { it.id != idUser }
        teamRepository.save(team)
    }

    fun persist(team: TeamDTO, username: String) {
        val user = userService.findUserByEmail(username) ?: throw UserNotFoundException()
        val team = teamRepository.save(Team(name = team.name, users = listOf(user)))
        val newUser = user.copy(teams = user.teams + team)
        userRepository.save(newUser)
    }

    fun addUser(id: Int, user: User) {
        val team = teamRepository.findByIdOrNull(id) ?: throw NotFoundException("No se encontro el grupo")
        teamRepository.save(team.copy(users = team.users + user))
    }

    fun notify(id: Int, notification: NotificationDTO) {
        val team = teamRepository.findByIdOrNull(id) ?: throw NotFoundException("No se encontro el grupo")
        team.users.forEach { it ->
            userService.addNotification(it.id, notification)
        }
    }

    fun addTraining(id: Int, position: String?, training: TrainingTeamDTO) {
        val team = teamRepository.findByIdOrNull(id) ?: throw NotFoundException("No se encontro el grupo")
        val users = if (position != null) {
            team.users.filter { it.position?.name == position }.toList()
        } else team.users
        users.forEach { it ->
            userService.addTraining(it.id, training.id)
        }
    }

    fun quitFromTeam(id: Int, idGroup: Int) {
        val user = userRepository.findByIdOrNull(id) ?: throw UserNotFoundException()
        this.removeUser(id, idGroup)
        val teams = user.teams.filter { it.id != idGroup }
        userRepository.save(user.copy(teams = teams))
    }

    fun addUserToTeam(id: Int, idGroup: Int) {
        val user = userRepository.findByIdOrNull(id) ?: throw UserNotFoundException()
        val team = this.findById(idGroup)
        this.addUser(team.id, user)
        userRepository.save(user.copy(teams = user.teams + team))
    }
}