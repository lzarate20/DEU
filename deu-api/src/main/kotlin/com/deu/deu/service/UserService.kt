package com.deu.deu.service

import com.deu.deu.dto.*
import com.deu.deu.exception.LoginException
import com.deu.deu.exception.NotFoundException
import com.deu.deu.exception.UserNotFoundException
import com.deu.deu.model.Notification
import com.deu.deu.model.Team
import com.deu.deu.model.Training
import com.deu.deu.model.User
import com.deu.deu.repository.NotificationRepository
import com.deu.deu.repository.UserRepository
import com.deu.deu.utils.toDTO
import com.deu.deu.utils.toTeamUserDTO
import com.deu.deu.utils.toTrainingDTOResponse
import org.springframework.data.repository.findByIdOrNull
import org.springframework.stereotype.Service
import java.time.LocalDate
import java.time.LocalDateTime


@Service
class UserService(
    private val userRepository: UserRepository,
    private val trainingService: TrainingService,
    private val notificationRepository: NotificationRepository
) {

    fun findAllUsers(): List<UserDTOResponse> {
        val usersDTO = userRepository.findAll()
        return usersDTO.map(User::toDTO)
    }

    fun findUserById(id: Int): User? {
        return userRepository.findByIdOrNull(id)
    }

    fun persist(user: UserDTO) {
        val newUser = User(
            name = user.name,
            email = user.email,
            password = user.password,
            type = user.type,
            position = user.position
        )
        userRepository.save(newUser)
    }

    fun update(user: UserDTO) {
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
        val user = userRepository.findByIdOrNull(id) ?: throw UserNotFoundException()
        return user.teams.map(Team::toTeamUserDTO)
    }

    fun delete(id: Int) {
        val user = userRepository.findByIdOrNull(id) ?: throw UserNotFoundException()
        userRepository.delete(user)
    }

    fun login(loginDTO: LoginDTO): UserDTOResponse {
        val user = userRepository.findByEmail(loginDTO.email) ?: throw LoginException()
        return if (user.password == loginDTO.password) user.toDTO() else throw LoginException()

    }

    fun getNotifications(id: Int): List<Notification> {
        val user = userRepository.findByIdOrNull(id) ?: throw UserNotFoundException()
        return user.notifcations;
    }

    fun addNotification(id: Int, notificationDTO: NotificationDTO) {
        val user = userRepository.findByIdOrNull(id) ?: throw UserNotFoundException()
        val notification = Notification(
            message = notificationDTO.message,
            date = LocalDateTime.now(),
            viewed = false
        )
        val newUser = user.copy(notifcations = user.notifcations + notification)
        notificationRepository.save(notification)
        userRepository.save(newUser)
    }

    fun getUserTrainingsByDate(date: LocalDate, id:Int):List<TrainingDTOResponse> {
        val user = userRepository.findByIdOrNull(id) ?: throw UserNotFoundException()
        val filteredTrainings = user.trainings.filter { it-> it.date == date }.map{it->it.toTrainingDTOResponse()}
        return filteredTrainings
    }

    fun addTraining(id: Int, trainingId: Int) {
        val user = userRepository.findByIdOrNull(id) ?: throw UserNotFoundException()
        val training = trainingService.getTraining(trainingId) ?: throw NotFoundException("No se encontro el entrenamiento")
        val newUser = user.copy(trainings = user.trainings + training)
        userRepository.save(newUser)
    }


}