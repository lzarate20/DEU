package com.deu.deu.controller

import com.deu.deu.dto.*
import com.deu.deu.exception.InvalidUserIdException
import com.deu.deu.exception.UserNotFoundException
import com.deu.deu.jwt.JwtUserDetails
import com.deu.deu.model.Notification
import com.deu.deu.service.UserService
import com.deu.deu.utils.toDTO
import org.springframework.format.annotation.DateTimeFormat
import org.springframework.http.HttpStatus
import org.springframework.security.access.prepost.PreAuthorize
import org.springframework.security.core.annotation.AuthenticationPrincipal
import org.springframework.security.core.context.SecurityContextHolder
import org.springframework.security.core.userdetails.UserDetails
import org.springframework.web.bind.annotation.*
import org.springframework.web.server.ResponseStatusException
import java.time.LocalDate

@RestController()
@RequestMapping("/api")
class UserController(val userService: UserService) {

    @GetMapping("/users")
    fun getUsers(): List<UserDTOResponse> {
        return userService.findAllUsers()
    }

    @GetMapping("/users/{id}")
    fun getUserById(@PathVariable("id") id: Int): UserDTOResponse {
        return userService.findUserById(id)?.toDTO() ?: throw UserNotFoundException()
    }

    @PutMapping("/user")
    fun updateUser(@RequestBody user: UpdateUserDTO) {
        if (user.currentPassword != null && user.newPassword == null) {
            throw ResponseStatusException(
                HttpStatus.BAD_REQUEST,
                "Debe proporcionar la nueva contraseña si ingresa la contraseña actual"
            )
        }
        if (user.currentPassword == null && user.newPassword != null) {
            throw ResponseStatusException(
                HttpStatus.BAD_REQUEST,
                "Debe proporcionar la actual contraseña si ingresa una nueva contraseña"
            )
        }
        val authentication = SecurityContextHolder.getContext().authentication
        val principal = authentication.principal as JwtUserDetails
        val userId = principal.id
        userService.update(userId, user)
    }

    @DeleteMapping("/user/{id}")
    fun deleteUser(@PathVariable("id") id: Int) {
        userService.delete(id)
    }

    @GetMapping("/user/{id}/teams")
    fun getTeamsUser(@PathVariable("id") id: Int): List<TeamUserDTOResponse> {
        return userService.getTeams(id)
    }

    @GetMapping("/user/trainings")
    fun getTrainings(@RequestParam("date") @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) date: LocalDate, @RequestParam("id") id: Int):List<TrainingDTOResponse> {
        return userService.getUserTrainingsByDate(date,id)
    }

    @PostMapping("/user/training/{id}")
    fun postTrainingToUser(@PathVariable("id") id: Int,@RequestBody users:UserListRequest)
    {
        users.users.forEach{u->userService.addTraining(u,id)}
    }

    @GetMapping("/user/notifications")
    fun getNotifications(@AuthenticationPrincipal userDetails: JwtUserDetails):List<Notification>{
        return userService.getNotifications(userDetails.id)
    }

    @PostMapping("/user/notifications/viewed")
    fun markNotifcationsAsViewed(@AuthenticationPrincipal userDetails: UserDetails){
        userService.markNotificationsAsViewed(userDetails.username)
    }


}