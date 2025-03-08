package com.deu.deu.controller

import com.deu.deu.dto.ConfigDTO
import com.deu.deu.model.Config
import com.deu.deu.service.ConfigService
import com.deu.deu.utils.toDTO
import org.springframework.web.bind.annotation.*

@RestController
class ConfigController(val configService: ConfigService) {

    @GetMapping("/config/{id}")
    fun getConfig(@PathVariable("id") id: Int): ConfigDTO {
        return configService.getConfig(id).toDTO()
    }

    @PatchMapping("/config")
    fun updateConfig(@RequestBody config: ConfigDTO) {
        configService.updateConfig(config)
    }

}