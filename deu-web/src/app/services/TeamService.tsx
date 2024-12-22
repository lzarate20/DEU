import { Team } from "@/app/lib/definition";

export async function getTeams(ids?: number[]): Promise<Team[]> {
    try {
        const response = await fetch('/api/proxy/teams', {
            method: 'GET',
            headers: {
                'Content-Type': 'application/json'
            },
        });

        if (!response.ok) {
            throw new Error(`Failed to fetch teams: ${response.statusText}`);
        }

        const teams: Team[] = await response.json();

        // Si se proporcionan IDs, filtrar los equipos
        if (ids && ids.length > 0) {
            return teams.filter(team => ids.includes(team.id));
        }

        return teams;
    } catch (error) {
        console.error('Error fetching teams:', error);
        throw error;
    }
}