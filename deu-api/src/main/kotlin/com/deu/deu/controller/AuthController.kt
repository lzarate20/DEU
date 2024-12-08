package com.deu.deu.controller

import com.deu.deu.dto.LoginDTO
import com.deu.deu.dto.UserLoginResponse
import com.deu.deu.jwt.AuthenticationService
import org.springframework.web.bind.annotation.PostMapping
import org.springframework.web.bind.annotation.RequestBody
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RestController

@RestController
@RequestMapping("/api/auth")
class AuthController(
    private val authenticationService: AuthenticationService
) {
    @PostMapping
    fun authenticate(
        @RequestBody authRequest: LoginDTO
    ): UserLoginResponse = authenticationService.authentication(authRequest)
}