package com.deu.deu.jwt

import com.deu.deu.dto.LoginDTO
import com.deu.deu.dto.UserLoginResponse
import com.deu.deu.repository.UserRepository
import com.deu.deu.utils.toDTO
import org.springframework.beans.factory.annotation.Value
import org.springframework.security.authentication.AuthenticationManager
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken
import org.springframework.security.core.userdetails.UserDetails
import org.springframework.security.core.userdetails.UserDetailsService
import org.springframework.security.core.userdetails.UsernameNotFoundException
import org.springframework.stereotype.Service
import java.time.Instant
import java.util.*

@Service
class AuthenticationService(
    private val authManager: AuthenticationManager,
    private val userDetailsService: UserDetailsService,
    private val userRepository: UserRepository,
    private val tokenService: TokenService,
    @Value("\${jwt.accessTokenExpiration}") private val accessTokenExpiration: Long,
) {
    fun authentication(authenticationRequest: LoginDTO): UserLoginResponse {
        authManager.authenticate(
            UsernamePasswordAuthenticationToken(
                authenticationRequest.email,
                authenticationRequest.password
            )
        )

        val user = userDetailsService.loadUserByUsername(authenticationRequest.email)
        val accessToken = createAccessToken(user)
        val userResponse = userRepository.findByEmail(authenticationRequest.email)?.toDTO() ?: throw UsernameNotFoundException("Usuario no encontrado")

        return UserLoginResponse(
            token = accessToken,
            user = userResponse
        )
    }

    private fun createAccessToken(user: UserDetails): String {
        return tokenService.generateToken(
            subject = user.username,
            expiration = Date.from(Instant.now().plusSeconds(accessTokenExpiration))
        )
    }
}