package com.deu.deu.repository

import com.deu.deu.model.*
import org.springframework.data.jpa.repository.JpaRepository


interface UserRepository : JpaRepository<User, Int>{
    fun findByEmail(email: String): User?
}

interface ExerciseRepository : JpaRepository<Exercise, Int>
interface VideoRepository : JpaRepository<Video, Int>
interface TrainingRepository : JpaRepository<Training, Int>
interface CommentRepository : JpaRepository<Comment, Int>
interface ConfigRepository : JpaRepository<Config, Int>
interface TeamRepository : JpaRepository<Team, Int>