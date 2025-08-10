package com.deu.deu.controller

import com.deu.deu.dto.*
import com.deu.deu.exception.UserNotFoundException
import com.deu.deu.model.Notification
import com.deu.deu.service.UserService
import com.deu.deu.utils.toDTO
import org.springframework.format.annotation.DateTimeFormat
import org.springframework.security.access.prepost.PreAuthorize
import org.springframework.security.core.annotation.AuthenticationPrincipal
import org.springframework.security.core.userdetails.UserDetails
import org.springframework.web.bind.annotation.*
import java.time.LocalDate

@RestController
class UserController(val userService: UserService) {

    @GetMapping("/users")
    @PreAuthorize("hasAuthority('ROLE_TRAINER')")
    fun getUsers(): List<UserDTOResponse> {
        return userService.findAllUsers()
    }

    @GetMapping("/users/{id}")
    fun getUserById(@PathVariable("id") id: Int): UserDTOResponse {
        return userService.findUserById(id)?.toDTO() ?: throw UserNotFoundException()
    }

    @PutMapping("/user")
    fun updateUser(@RequestBody user: UserDTO){
        userService.update(user)
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

    @GetMapping("/user/notifications")
    fun getNotifications(@AuthenticationPrincipal userDetails: UserDetails):List<Notification>{
        return userService.getNotifications(userDetails.username)
    }

    @PostMapping("/user/notifications/viewed")
    fun markNotifcationsAsViewed(@AuthenticationPrincipal userDetails: UserDetails){
        userService.markNotificationsAsViewed(userDetails.username)
    }


}