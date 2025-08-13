package com.deu.deu.model

import com.fasterxml.jackson.annotation.JsonIgnore
import jakarta.persistence.*
import java.time.LocalDate
import java.time.LocalDateTime
import java.util.Date

@Entity
@Table(name = "appUser",uniqueConstraints = [UniqueConstraint(columnNames = ["email"])])
data class User(
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    val id: Int = 0,
    val name: String,
    @Column(nullable = false, unique = true)
    val email: String,
    val password: String,
    @Enumerated(EnumType.STRING)
    val type: UserType,
    @Enumerated(EnumType.STRING)
    val position: Position? = null,
    @ManyToMany(mappedBy = "users")
    val teams: List<Team> = listOf(),
    @OneToMany(cascade = [CascadeType.ALL])
    val notifcations: List<Notification> = mutableListOf(),
    @ManyToMany(cascade = [CascadeType.ALL])
    val trainings: List<Training> = listOf()
)

@Entity
data class Exercise(
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    val id: Int = 0,
    val name: String,
    val description: String,
    val time: Int?,
    @Enumerated(EnumType.STRING)
    val units: UnitsType?,
    val count: Int,
    val type: TimeType,
    val category: ExerciseType,
    @ManyToOne
    val video: Video,
    val isVisible: Boolean
)

@Entity
data class Video(
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    val id: Int = 0,
    val name: String,
    val url: String
)

@Entity
data class Training(
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    val id: Int = 0,
    val name: String,
    val description: String?,
    @ManyToOne
    @JoinColumn(name = "trainer_id")
    val trainer: User,
    val date: LocalDate,
    @Enumerated(EnumType.STRING)
    val type: TrainingType,
    @ManyToMany()
    val exercises: List<Exercise> = listOf(),
    @OneToMany(cascade = [CascadeType.ALL])
    val comments: List<Comment> = listOf(),
    @ManyToMany
    @JoinTable(
        name = "training_trainees",
        joinColumns = [JoinColumn(name = "training_id")],
        inverseJoinColumns = [JoinColumn(name = "user_id")]
    )
    val trainees: List<User> = listOf()
)

@Entity
data class Comment(
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    val id: Int = 0,
    @ManyToOne
    val idUser: User,
    val comment: String
)

@Entity
data class Config(
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    val id: Int = 0,
    @OneToOne
    val user: User,
    @Enumerated(EnumType.STRING)
    val theme: ThemeType,
    @Enumerated(EnumType.STRING)
    val letterSize: LetterSize
)

@Entity
data class Team(
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    val id: Int = 0,
    val name: String,
    @ManyToMany
    @JsonIgnore
    @JoinTable(
        name = "user_team",
        joinColumns = [JoinColumn(name = "team_id")],
        inverseJoinColumns = [JoinColumn(name = "user_id")]
    )
    val users: List<User> = listOf()
)

@Entity
data class Notification(
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    val id: Int = 0,
    val message: String,
    val date: LocalDateTime,
    val viewed: Boolean,
    val context: NotificationContext
)

@Embeddable
data class NotificationContext(
    val type: String,
    val contextId: String,
)
