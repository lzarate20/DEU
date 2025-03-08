"use client";

import { useEffect, useState } from "react";
import CookieService from "@/app/services/CookieService";
import styles from '../styles/MyTeams.module.css';
import { getTeams } from "@/app/services/TeamService";
import { Team } from "@/app/lib/definition";

function MyTeams() {
    const [teams, setTeams] = useState<Team[]>([]);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState<string | null>(null);
    const myTeams = CookieService.getUser()?.teams ?? [];

    useEffect(() => {
        // Verificar si los equipos ya están almacenados en sessionStorage
        const storedTeams = sessionStorage.getItem("teams");
        const storedLoadingState = sessionStorage.getItem("loading");

        if (storedTeams && storedLoadingState === "false") {
            // Si ya tenemos los equipos y no estamos cargando, usamos los equipos almacenados
            setTeams(JSON.parse(storedTeams));
            setLoading(false);
        } else {
            const fetchTeams = async () => {
                try {
                    const teamsId = myTeams.map(team => team.id);
                    const fetchedTeams = await getTeams(teamsId);
                    setTeams(fetchedTeams);

                    // Almacenar los equipos en sessionStorage
                    sessionStorage.setItem("teams", JSON.stringify(fetchedTeams));
                } catch (error) {
                    setError("Hubo un error al cargar los equipos.");
                    console.error("Error fetching teams:", error);
                } finally {
                    // Almacenar el estado de carga en sessionStorage
                    sessionStorage.setItem("loading", "false");
                    setLoading(false);
                }
            };

            fetchTeams();
        }
    }, []); // Solo se ejecuta una vez cuando el componente se monta

    if (loading) {
        return <div className={styles.spinner}></div>; // Muestra el spinner mientras carga
    }

    if (error) {
        return <div>{error}</div>; // Muestra el mensaje de error si ocurre
    }

    return (
        <div className={styles.container}>
            <h1>Mis equipos</h1>
            <div className={styles.cardContainer}>
                {teams.length > 0 ? (
                    teams.map((team) => (
                        <div className={styles.card} key={team.id.toString()}>
                            <h2>{team.name}</h2>
                            <h2>Size: {team.users.length}</h2>
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
