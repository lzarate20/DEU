package com.deu.deu.repository

import com.deu.deu.model.*
import org.springframework.data.repository.CrudRepository


interface UserRepository : CrudRepository<User, Int> {
    fun findByEmail(email: String): User?
}

interface ExerciseRepository : CrudRepository<Exercise, Int>
interface VideoRepository : CrudRepository<Video, Int>
interface TrainingRepository : CrudRepository<Training, Int>
interface CommentRepository : CrudRepository<Comment, Int>
interface ConfigRepository : CrudRepository<Config, Int>{
    fun findByUserId(userId: Int): Config?
}
interface TeamRepository : CrudRepository<Team, Int>