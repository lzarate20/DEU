package com.deu.deu

import org.springframework.boot.autoconfigure.SpringBootApplication
import org.springframework.boot.runApplication
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity

@EnableWebSecurity
@SpringBootApplication
class DeuApplication

fun main(args: Array<String>) {
	runApplication<DeuApplication>(*args)
}
