package com.deu.deu.controller

import com.deu.deu.dto.LoginDTO
import com.deu.deu.dto.UserDTO
import com.deu.deu.dto.UserLoginResponse
import com.deu.deu.jwt.AuthenticationService
import com.deu.deu.service.UserService
import org.springframework.web.bind.annotation.PostMapping
import org.springframework.web.bind.annotation.RequestBody
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RestController

@RestController
@RequestMapping("/api/auth")
class AuthController(
    private val authenticationService: AuthenticationService,
    private val userService: UserService
) {
    @PostMapping
    fun authenticate(
        @RequestBody authRequest: LoginDTO
    ): UserLoginResponse = authenticationService.authentication(authRequest)

    @PostMapping("/user")
    fun createUser(@RequestBody user: UserDTO){
        userService.persist(user)
    }
}