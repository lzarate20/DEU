package com.deu.deu.jwt

import jakarta.servlet.FilterChain
import jakarta.servlet.http.HttpServletRequest
import jakarta.servlet.http.HttpServletResponse
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken
import org.springframework.security.core.authority.SimpleGrantedAuthority
import org.springframework.security.core.context.SecurityContextHolder
import org.springframework.security.web.authentication.WebAuthenticationDetailsSource
import org.springframework.stereotype.Component
import org.springframework.web.filter.OncePerRequestFilter

@Component
class JwtAuthorizationFilter(
    private val userDetailsService: JwtUserDetailsService,
    private val tokenService: TokenService
) : OncePerRequestFilter() {
    override fun doFilterInternal(
        request: HttpServletRequest,
        response: HttpServletResponse,
        filterChain: FilterChain
    ) {
        val authorizationHeader: String? = request.getHeader("Authorization")

        if (null != authorizationHeader && authorizationHeader.startsWith("Bearer ")) {
            try {
                val token: String = authorizationHeader.substringAfter("Bearer ")
                val userId: String = tokenService.extractUserId(token)

                if (SecurityContextHolder.getContext().authentication == null) {
                    val userDetails: JwtUserDetails = userDetailsService.loadUserById(userId.toInt())
                    val claims = tokenService.extractAllClaims(token)
                    val authoritiesFromToken = claims["authorities"] as List<*>
                    val authorities = authoritiesFromToken
                        .mapNotNull { it?.toString() }
                        .map { SimpleGrantedAuthority(it) }

                    if (userId == userDetails.id.toString()) {
                        val authToken = UsernamePasswordAuthenticationToken(
                            userDetails, null, authorities
                        )
                        authToken.details = WebAuthenticationDetailsSource().buildDetails(request)
                        SecurityContextHolder.getContext().authentication = authToken
                    }
                }
            } catch (ex: Exception) {
                response.writer.write(
                    """{"error": "Filter Authorization error: 
                    |${ex.message ?: "unknown error"}"}""".trimMargin()
                )
            }
        }

        filterChain.doFilter(request, response)
    }
}