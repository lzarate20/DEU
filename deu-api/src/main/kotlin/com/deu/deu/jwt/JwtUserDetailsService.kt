package com.deu.deu.jwt

import com.deu.deu.repository.UserRepository
import org.springframework.security.core.authority.SimpleGrantedAuthority
import org.springframework.security.core.userdetails.UserDetailsService
import org.springframework.security.core.userdetails.UsernameNotFoundException
import org.springframework.stereotype.Component

@Component
class JwtUserDetailsService(
    private val userRepository: UserRepository
) : UserDetailsService {
    override fun loadUserByUsername(email: String): JwtUserDetails {
        val user = userRepository.findByEmail(email)
            ?: throw UsernameNotFoundException("Usuario $email no encontrado")

        return JwtUserDetails(
            id = user.id,
            email = user.email,
            password = user.password,
            authorities = listOf(SimpleGrantedAuthority(user.type.name))
        )
    }

    fun loadUserById(userId: Int): JwtUserDetails {
        val user = userRepository.findById(userId)
            .orElseThrow { UsernameNotFoundException("Usuario $userId no encontrado") }

        return JwtUserDetails(
            id = user.id,
            email = user.email,
            password = user.password,
            authorities = listOf(SimpleGrantedAuthority(user.type.name))
        )
    }

}