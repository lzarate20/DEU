"use client";

import {useEffect, useState} from "react";
import CookieService from "@/app/services/CookieService";
import styles from '../styles/MyTeams.module.css';
import {getTrainings} from "@/app/services/TrainingService";
import {Training} from "@/app/lib/definition";
import Image from 'next/image';
import {useRouter} from "next/navigation";

function MyTrainings({selectedDate}) {
    const formatDateKey = (date) => date.toISOString().split('T')[0];
    const [trainings, setTrainings] = useState<Training[]>([]);
    const [loading, setLoading] = useState(true);
    const userId = CookieService.getUser()?.id;

    const router = useRouter();
    const handleClick = (training) => {
        sessionStorage.setItem("selectedTraining", JSON.stringify(training));
        router.push(`/training/${training.id}`);
    };

    useEffect(() => {
        const fetchTeams = async () => {
            try {
                if (userId != null) {
                    const fetchedTrainings = await getTrainings(userId, formatDateKey(selectedDate));
                    setTrainings(fetchedTrainings);
                    console.log(fetchedTrainings);
                }
            } catch (error) {
                console.error("Error fetching teams:", error);
            } finally {
                setLoading(false);
            }
        };

        fetchTeams();
    }, [selectedDate]);

    if (loading) {
        return <div>Loading...</div>;
    }

    return (
        <div className={styles.container}>
            <h1>Mis entrenamientos</h1>
            <div className={styles.cardContainer}>
                {trainings.length > 0 ? (
                    trainings.map((training) => (
                        <div className={styles.card} key={training.id.toString()} onClick={() => handleClick(training)}>
                            <h2>{training.name}</h2>
                            <h2>{training.type}</h2>
                            <h2><Image width={30} height={30} src="/icon/weightlifting.ico" alt={"fuerza"}></Image>Exercises
                                count:</h2>
                        </div>
                    ))
                ) : (
                    <p>No hay entrenamientos</p>
                )}
            </div>
        </div>
    );
}

export default MyTrainings;