package com.deu.deu.repository.spec

import com.deu.deu.model.Exercise
import com.deu.deu.model.ExerciseType
import org.springframework.data.jpa.domain.Specification

fun byName(name: String): Specification<Exercise> {
    return Specification { root, _, cb ->
        cb.like(cb.lower(root.get("name")), "%${name.lowercase()}%")
    }
}

fun byCategory(category: ExerciseType): Specification<Exercise> {
    return Specification { root, _, cb ->
        cb.equal(root.get<ExerciseType>("category"), category)
    }
}

fun byVisibility(visible: Boolean): Specification<Exercise> {
    return Specification { root, _, cb ->
        cb.equal(root.get<Boolean>("isVisible"), visible)
    }
}