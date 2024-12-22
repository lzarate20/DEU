export interface User {
    id: bigint;
    name: string;
    email: string;
    type: string;
    teams: Array<Team>;
}

export interface TeamUser{
    id:bigint,
    name: string
}

export interface UserTeam {
    id: bigint,
    name: string,
    email: string,
    type: string,
    position: string,
    teams: Array<TeamUser>
}

export interface Team {
    id: bigint,
    name: string,
    users: Array<UserTeam>;
}

export interface LoginPayload{
    user:User;
    token:string;
    expirationDate:Date
}

export interface Exercise {
    id: bigint,
    name: string,
    description: string,
    time: UnitsType,
    units: string,
    count: bigint,
    type: TimeType,
    category: ExerciseType,
    video: Video
    isVisible: boolean
}

export interface Training {
    id: bigint,
    name: string,
    description: string,
    trainer: User,
    date: Date,
    type: TrainingType,
    exercises: Array<Exercise>,
    comments: Array<Comments>
}

export interface Comments{
    id:bigint,
    idUser: User,
    comment: string
}

export const TrainingType = {
    STRENGTH: "STRENGTH",
    SPEED: "SPEED",
    DRIBBLING: "DRIBBLING",
} as const;

export type TrainingType = (typeof TrainingType)[keyof typeof TrainingType];

export const ExerciseType = {
    WARMUP: "WARMUP",
    TRAINING: "TRAINING",
    RECOVERY: "RECOVERY",
} as const;

export type ExerciseType = (typeof ExerciseType)[keyof typeof ExerciseType];

export const TimeType = {
    REPETITION: "REPETITION",
    TIME: "TIME",
} as const;

export type TimeType = (typeof TimeType)[keyof typeof TimeType];

export interface Video{
    id:bigint,
    name:string,
    url:string
}

export const UnitsType = {
    SEC: "SEC",
    MIN: "MIN",
    HOUR: "HOUR",
} as const;

export type UnitsType = (typeof UnitsType)[keyof typeof UnitsType];