package com.deu.deu.exception

class UserNotFoundException(
    email: String? = null
) : Exception("No se encontro el usuario $email")

class LoginException(
) : Exception("El email, la contraseña o ambos son incorrectos")

class NotFoundException(
    msg: String? = null
) : Exception(msg)

class MissingParamException(
    msg: String? = null
) : Exception(msg)