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
import java.time.LocalDateTime
import java.util.*

@Service
class AuthenticationService(
    private val authManager: AuthenticationManager,
    private val userDetailsService: JwtUserDetailsService,
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

        val userEntity = userRepository.findByEmail(authenticationRequest.email)
            ?: throw UsernameNotFoundException("Usuario no encontrado")

        val userDetails = userDetailsService.loadUserByUsername(userEntity.email)

        val accessToken = createAccessToken(userDetails)

        val userResponse = userEntity.toDTO()

        return UserLoginResponse(
            token = accessToken,
            user = userResponse,
            expirationDate = LocalDateTime.now().plusSeconds(accessTokenExpiration)
        )
    }


    private fun createAccessToken(user: JwtUserDetails): String {
        return tokenService.generateToken(
            userId = user.id.toString(),
            expiration = Date.from(Instant.now().plusSeconds(accessTokenExpiration)),
            additionalClaims = mapOf(
                "authorities" to user.authorities.map { it.authority },
                "userId" to user.id
            )
        )
    }
}