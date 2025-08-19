package com.deu.deu.exception

import org.springframework.http.HttpStatus
import org.springframework.web.bind.annotation.ResponseStatus

class UserNotFoundException(
    email: String? = null
) : Exception("No se encontro el usuario $email")

class UserAlreadyAreInTeamException(
): Exception("El usuario ya se encuentra en el equipo")

class LoginException(
) : Exception("El email, la contraseña o ambos son incorrectos")

class NotFoundException(
    msg: String? = null
) : Exception(msg)

class MissingParamException(
    msg: String? = null
) : Exception(msg)

class InvalidUserIdException(
    msg: String? = null
) : Exception(msg)

@ResponseStatus(HttpStatus.BAD_REQUEST)
class InvalidTrainingDateException(message: String) : BadRequest(message)

@ResponseStatus(HttpStatus.BAD_REQUEST)
class InvalidEvaluationScore(message: String) : BadRequest(message)

@ResponseStatus(HttpStatus.BAD_REQUEST)
open class BadRequest(message: String) : RuntimeException(message)