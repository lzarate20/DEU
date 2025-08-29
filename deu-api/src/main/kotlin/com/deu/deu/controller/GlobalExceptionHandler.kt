package com.deu.deu.controller

import com.deu.deu.exception.*
import jakarta.servlet.http.HttpServletRequest
import mu.KotlinLogging
import org.springframework.http.HttpStatus
import org.springframework.http.ResponseEntity
import org.springframework.http.converter.HttpMessageNotReadableException
import org.springframework.web.bind.annotation.ControllerAdvice
import org.springframework.web.bind.annotation.ExceptionHandler
import org.springframework.web.bind.annotation.ResponseStatus


@ControllerAdvice
class GlobalExceptionHandler {
    private val log = KotlinLogging.logger {}

    @ExceptionHandler(
        UserNotFoundException::class,
        LoginException::class,
        NotFoundException::class,
        MissingParamException::class
    )
    @ResponseStatus(HttpStatus.BAD_REQUEST)
    fun handleBadRequest(e: Exception): ResponseEntity<ErrorResponse> {
        return ResponseEntity(ErrorResponse(code=HttpStatus.BAD_REQUEST.value(),e.message?:"Bad Request"), HttpStatus.BAD_REQUEST)
    }

    @ExceptionHandler(HttpMessageNotReadableException::class)
    fun handleNotReadable(ex: HttpMessageNotReadableException, request: HttpServletRequest): ResponseEntity<String> {
        log.warn { "Request failed: ${request.method} ${request.requestURI}" }

        // Log headers
        val headers = request.headerNames.toList().associateWith { request.getHeader(it) }
        log.warn { "Headers: $headers" }

        // Log body
        val body = request.reader.use { it.readText() }
        log.warn { "Body: $body" }

        return ResponseEntity("Malformed request body", HttpStatus.BAD_REQUEST)
    }

}