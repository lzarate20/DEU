package com.deu.deu.controller

import com.deu.deu.dto.*
import com.deu.deu.model.Team
import com.deu.deu.model.User
import com.deu.deu.service.UserService
import org.springframework.web.bind.annotation.*

@RestController
class UserController(val userService: UserService) {

    @GetMapping("/users")
    fun getUsers(): List<UserDTOResponse> {
        return userService.findAllUsers()
    }

    @GetMapping("/users/{id}")
    fun getUserById(@PathVariable("id") id: Int): UserDTOResponse {
        return userService.findUserById(id)
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

    @PostMapping("/login")
    fun login(@RequestBody loginDto: LoginDTO): UserDTOResponse {
       return userService.login(loginDto)
    }

    @GetMapping("/user/{id}/teams")
    fun getTeamsUser(@PathVariable("id") id: Int): List<TeamUserDTOResponse> {
        return userService.getTeams(id)
    }

    @DeleteMapping("/user/{id}/teams/{idTeam}")
    fun removeUserFromTeam(@PathVariable("id") id: Int, @PathVariable("idTeam") team: Int) {
        userService.quitFromTeam(id,team)
    }

    @PostMapping("/users/{id}/team/{idTeam}")
    fun addUserToTeam(@PathVariable("id") id: Int, @PathVariable("idTeam") team: Int) {
        userService.addUserToTeam(id, team)
    }


}