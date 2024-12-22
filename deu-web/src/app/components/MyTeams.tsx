"use client";

import { useEffect, useState } from "react";
import CookieService from "@/app/services/CookieService";
import styles from '../styles/MyTeams.module.css';
import { getTeams } from "@/app/services/TeamService";
import {Team} from "@/app/lib/definition";

function MyTeams() {
    const [teams, setTeams] = useState<Team[]>([]);
    const [loading, setLoading] = useState(true);
    const myTeams = CookieService.getUser()?.teams ?? [];

    useEffect(() => {
        const fetchTeams = async () => {
            try {
                const teamsId = myTeams.map(team=> team.id)
                const fetchedTeams = await getTeams(teamsId);
                setTeams(fetchedTeams);
            } catch (error) {
                console.error("Error fetching teams:", error);
            } finally {
                setLoading(false);
            }
        };

        fetchTeams();
    }, []);

    if (loading) {
        return <div>Loading...</div>;
    }

    return (
        <div className={styles.container}>
            <h1>Mis equipos</h1>
            <div className={styles.cardContainer}>
                {teams.length > 0 ? (
                    teams.map((team) => (
                        <div className={styles.card} key={team.id.toString()}>
                            <h2>{team.name}</h2>
                            <h2>Size:{team.users.length}</h2>
                        </div>
                    ))
                ) : (
                    <p>No hay equipos coincidentes.</p>  // Muestra un mensaje si no hay coincidencias
                )}
            </div>
        </div>
    );
}

export default MyTeams;