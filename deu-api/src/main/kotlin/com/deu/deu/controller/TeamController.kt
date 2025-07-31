package com.deu.deu.controller

import com.deu.deu.dto.*
import com.deu.deu.model.Team
import com.deu.deu.model.Training
import com.deu.deu.service.TeamService
import com.deu.deu.service.UserService
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

    @PostMapping("/team/notify")
    fun postNotification(@RequestParam("team_id")id:Int,@RequestBody notification: NotificationDTO){
        return teamService.notify(id,notification)
    }

    @PostMapping("/team/training")
    fun postTraining(@RequestParam("team_id")id:Int,@RequestParam("position")position:String?,@RequestBody training: TrainingTeamDTO){
        return teamService.addTraining(id,position,training)
    }

    @DeleteMapping("/teams/{idTeam}/user/{id}")
    fun removeUserFromTeam(@PathVariable("id") id: Int, @PathVariable("idTeam") team: Int) {
        teamService.quitFromTeam(id,team)
    }

    @PostMapping("/teams/{idTeam}/user/{id}")
    fun addUserToTeam(@PathVariable("id") id: Int, @PathVariable("idTeam") team: Int) {
        teamService.addUserToTeam(id, team)
    }

}