package com.deu.deu.service

import com.deu.deu.dto.LoginDTO
import com.deu.deu.dto.TeamUserDTOResponse
import com.deu.deu.dto.UserDTO
import com.deu.deu.dto.UserDTOResponse
import com.deu.deu.exception.LoginException
import com.deu.deu.exception.UserNotFoundException
import com.deu.deu.model.Team
import com.deu.deu.model.User
import com.deu.deu.repository.UserRepository
import com.deu.deu.utils.toDTO
import com.deu.deu.utils.toTeamUserDTO
import org.springframework.stereotype.Service


@Service
class UserService(
    private val userRepository: UserRepository,
    private val teamService: TeamService
) {

    fun findAllUsers(): List<UserDTOResponse> {
        val usersDTO = userRepository.findAll()
        return usersDTO.map(User::toDTO)
    }

    fun findUserById(id: Int): UserDTOResponse {
        return userRepository.findById(id).orElseThrow { UserNotFoundException() }.toDTO()
    }

    fun persist(user: UserDTO){
        val newUser = User(
            name = user.name,
            email = user.email,
            password = user.password,
            type = user.type,
            position = user.position
        )
        userRepository.save(newUser)
    }

    fun update(user: UserDTO){
        val userOpt = userRepository.findByEmail(user.email) ?: throw UserNotFoundException(user.email)
        val newUser = userOpt.copy(
            name = user.name,
            email = user.email,
            password = user.password,
            type = user.type,
            position = user.position
        )
        userRepository.save(newUser)
    }

    fun getTeams(id: Int): List<TeamUserDTOResponse> {
        val user = userRepository.findById(id).orElseThrow { UserNotFoundException() }
        return user.teams.map(Team::toTeamUserDTO)
    }

    fun delete(id: Int) {
        val user = userRepository.findById(id).orElseThrow { UserNotFoundException() }
        userRepository.delete(user)
    }

    fun login(loginDTO: LoginDTO): UserDTOResponse {
        val user = userRepository.findByEmail(loginDTO.email) ?: throw LoginException()
        return if (user.password == loginDTO.password) user.toDTO() else throw LoginException()

    }

    fun quitFromTeam(id: Int, idGroup: Int) {
        val user = userRepository.findById(id).orElseThrow { UserNotFoundException() }
        teamService.removeUser(id, idGroup)
        val teams = user.teams.filter { it.id != idGroup }
        userRepository.save(user.copy(teams = teams))
    }

    fun addUserToTeam(id:Int,idGroup: Int){
        val user = userRepository.findById(id).orElseThrow { UserNotFoundException() }
        val team = teamService.findById(idGroup)
        teamService.addUser(team.id,user)
        userRepository.save(user.copy(teams = user.teams+team))
    }


}