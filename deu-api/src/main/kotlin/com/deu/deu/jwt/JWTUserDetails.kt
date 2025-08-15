package com.deu.deu.jwt

import org.springframework.security.core.GrantedAuthority
import org.springframework.security.core.userdetails.UserDetails

data class JwtUserDetails(
    val id: Int,
    private val email: String,
    private val password: String,
    private val authorities: Collection<GrantedAuthority>
) : UserDetails {
    override fun getUsername() = email
    override fun getPassword() = password
    override fun getAuthorities() = authorities
    override fun isAccountNonExpired() = true
    override fun isAccountNonLocked() = true
    override fun isCredentialsNonExpired() = true
    override fun isEnabled() = true
}
