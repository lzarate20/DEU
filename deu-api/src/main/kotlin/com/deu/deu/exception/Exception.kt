package com.deu.deu.exception

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