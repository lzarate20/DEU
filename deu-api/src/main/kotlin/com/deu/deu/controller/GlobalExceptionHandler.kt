package com.deu.deu.controller

import com.deu.deu.exception.*
import org.springframework.http.HttpStatus
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.ControllerAdvice
import org.springframework.web.bind.annotation.ExceptionHandler
import org.springframework.web.bind.annotation.ResponseStatus

@ControllerAdvice
class GlobalExceptionHandler {

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

}