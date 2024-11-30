package com.deu.deu.controller

import com.deu.deu.dto.TeamDTO
import com.deu.deu.dto.TeamDTOResponse
import com.deu.deu.model.Team
import com.deu.deu.service.TeamService
import org.springframework.web.bind.annotation.*

@RestController
class TeamController(val teamService: TeamService) {

    @GetMapping( "/teams")
    fun getGroups() : List<TeamDTOResponse>{
        return teamService.findAll()
    }

    @DeleteMapping("/team/{id}")
    fun deleteGroup(@PathVariable("id") id: Int){
        return teamService.delete(id)
    }

    @PostMapping("/team")
    fun postGroup(@RequestBody group: TeamDTO){
        return teamService.persist(group)
    }

}