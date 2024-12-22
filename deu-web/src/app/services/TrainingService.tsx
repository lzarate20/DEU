import {Training} from "@/app/lib/definition";

export async function getTrainings(id:bigint): Promise<Training[]> {
    try {
        const response = await fetch(`/api/proxy/user/trainings?user_id=${id}`, {
            method: 'GET',
            headers: {
                'Content-Type': 'application/json'
            },
        });

        if (!response.ok) {
            throw new Error(`Failed to fetch trainings: ${response.statusText}`);
        }

        const traings: Training[] = await response.json();
        return traings;
    } catch (error) {
        console.error('Error fetching teams:', error);
        throw error;
    }
}