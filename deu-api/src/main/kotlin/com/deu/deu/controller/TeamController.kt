package com.deu.deu.controller

import com.deu.deu.dto.*
import com.deu.deu.jwt.JwtUserDetails
import com.deu.deu.model.Team
import com.deu.deu.model.Training
import com.deu.deu.service.TeamService
import com.deu.deu.service.UserService
import com.deu.deu.utils.toDTO
import org.springframework.security.core.Authentication
import org.springframework.web.bind.annotation.*

@RestController()
@RequestMapping("/api")
class TeamController(val teamService: TeamService) {
    @GetMapping( "/teams")
    fun getGroups() : List<TeamDTOResponse>{
        return teamService.findAll()
    }

    @GetMapping( "/teams/{id}")
    fun getGroupById(@PathVariable("id") id: Int) : TeamDTOResponse{
        return teamService.findById(id).toDTO()
    }


    @DeleteMapping("/team/{id}")
    fun deleteGroup(@PathVariable("id") id: Int){
        return teamService.delete(id)
    }

    @PostMapping("/team")
    fun postGroup(
        @RequestBody group: TeamDTO,
        authentication: Authentication
    ) {
        val principal = authentication.principal as JwtUserDetails
        val userId = principal.id

        return teamService.persist(group, userId)
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