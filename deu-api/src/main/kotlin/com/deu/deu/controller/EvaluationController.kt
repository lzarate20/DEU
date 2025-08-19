package com.deu.deu.controller

import com.deu.deu.dto.EvaluationDTO
import com.deu.deu.exception.InvalidUserIdException
import com.deu.deu.jwt.JwtUserDetails
import com.deu.deu.service.EvaluationService
import com.deu.deu.service.UserService
import com.deu.deu.utils.toEvaluationDTO
import org.springframework.data.jpa.repository.Query
import org.springframework.security.access.prepost.PreAuthorize
import org.springframework.security.core.annotation.AuthenticationPrincipal
import org.springframework.web.bind.annotation.*

@RestController
class EvaluationController(
    private val evaluationService: EvaluationService,
    private val userService: UserService
) {

    @PostMapping("/evaluation")
    fun postEvaluation(
        @AuthenticationPrincipal userDetails: JwtUserDetails,
        @RequestBody evaluationDTO: EvaluationDTO
    ): EvaluationDTO {
        val user = userService.findUserById(userDetails.id) ?: throw InvalidUserIdException()
        return evaluationService.addEvaluation(evaluationDTO, user)
    }

    @GetMapping("/evaluation/{trainingId}")
    fun getMyEvaluation(@AuthenticationPrincipal userDetails: JwtUserDetails, @PathVariable("trainingId") trainingId: Int): EvaluationDTO? {
        val user = userService.findUserById(userDetails.id) ?: throw InvalidUserIdException()
        return evaluationService.getMyEvaluation(trainingId, user)?.toEvaluationDTO()
    }

    @GetMapping("/evaluation")
    fun getEvaluationFromUserTarget(@AuthenticationPrincipal userDetails: JwtUserDetails, @RequestParam("userId") userId:Int, @RequestParam("trainingId") trainingId: Int): EvaluationDTO? {
        val user = userService.findUserById(userDetails.id) ?: throw InvalidUserIdException()
        val userTarget = userService.findUserById(userId) ?: throw InvalidUserIdException()
        return evaluationService.getMyEvaluationToUser(trainingId, user,userTarget)?.toEvaluationDTO()
    }

    @PreAuthorize("hasRole('TRAINER')")
    @GetMapping("/evaluations/{trainingId}")
    fun getMyEvaluations(@AuthenticationPrincipal userDetails: JwtUserDetails, @PathVariable("trainingId") trainingId: Int): EvaluationDTO {
        val user = userService.findUserById(userDetails.id) ?: throw InvalidUserIdException()
        return evaluationService.getAverageEvaluation(trainingId, user)
    }
}