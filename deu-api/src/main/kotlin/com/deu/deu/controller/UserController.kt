package com.deu.deu.controller

import com.deu.deu.dto.*
import com.deu.deu.exception.UserNotFoundException
import com.deu.deu.model.Notification
import com.deu.deu.model.Team
import com.deu.deu.model.User
import com.deu.deu.service.UserService
import com.deu.deu.utils.toDTO
import org.springframework.web.bind.annotation.*

@RestController
class UserController(val userService: UserService) {

    @GetMapping("/users")
    fun getUsers(): List<UserDTOResponse> {
        return userService.findAllUsers()
    }

    @GetMapping("/users/{id}")
    fun getUserById(@PathVariable("id") id: Int): UserDTOResponse {
        return userService.findUserById(id)?.toDTO() ?: throw UserNotFoundException()
    }

    @PostMapping("/user")
    fun postUser(@RequestBody user: UserDTO){
        userService.persist(user)
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

    @GetMapping("/user/notifications")
    fun getNotifications(@RequestParam("user_id") id: Int):List<Notification>{
        return userService.getNotifications(id)
    }

    @GetMapping("/user/trainings")
    fun getTrainings(@RequestParam("user_id") id: Int):List<TrainingDTOResponse> {
        return userService.getTrainings(id)
    }


}