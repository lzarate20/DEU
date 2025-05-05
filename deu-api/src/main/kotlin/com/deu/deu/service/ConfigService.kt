package com.deu.deu.service

import com.deu.deu.dto.ConfigDTO
import com.deu.deu.exception.UserNotFoundException
import com.deu.deu.model.Config
import com.deu.deu.model.LetterSize
import com.deu.deu.model.ThemeType
import com.deu.deu.repository.ConfigRepository
import com.deu.deu.utils.toDTO
import org.springframework.stereotype.Service

@Service
class ConfigService(val configRepository: ConfigRepository, val userService: UserService) {

    fun getConfig(idUser: Int): Config {
        val user = userService.findUserById(idUser) ?: throw UserNotFoundException("No se encontro el usuario $idUser")
        return configRepository.findByUserId(idUser) ?: configRepository.save(
            Config(
                user = user,
                theme = ThemeType.DAY,
                letterSize = LetterSize.SMALL
            )
        )
    }

    fun updateConfig(newConfig: ConfigDTO): ConfigDTO {
        val config = getConfig(newConfig.idUser)
        return configRepository.save(config.copy(theme = newConfig.theme, letterSize = newConfig.letterSize)).toDTO()
    }


}