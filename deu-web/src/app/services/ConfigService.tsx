import {ConfigData, PatchConfigData} from "@/app/lib/definition";

export async function getConfig(id: number): Promise<ConfigData> {
    try {
        const response = await fetch(`/api/proxy/config/${id}`, {
            method: 'GET',
            headers: {
                'Content-Type': 'application/json'
            },
        });

        if (!response.ok) {
            throw new Error(`Failed to fetch config: ${response.statusText}`);
        }

        const configData: ConfigData = await response.json();

        return configData;
    } catch (error) {
        console.error('Error fetching config:', error);
        throw error;
    }
}

export async function patchConfig(config: PatchConfigData) {
    try {
        const response = await fetch('/api/proxy/config', {
            method: 'PATCH',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(config),
        });

        if (!response.ok) {
            throw new Error(`Failed to post config: ${response.statusText}`);
        }
    } catch (error) {
        console.error('Error posting config:', error);
        throw error;
    }
}