import {getJWT} from "@/app/lib/session";
import {NextRequest} from "next/server";

export async function GET(request: NextRequest) {
    const loginPayload = await getJWT()
    if (!loginPayload) {
        return new Response(JSON.stringify({error: 'Token not found in cookies'}), {
            status: 401,
        });
    }

    const url = new URL(request.url);

    const originalUrl = `http://localhost:8080${url.pathname}${url.search}`;
    const targetUrl = originalUrl.toString().replace('/api/proxy', '');

    const fetchOptions: RequestInit = {
        method: request.method,
        headers: {
            'Authorization': `Bearer ${loginPayload.token}`,
            'Content-Type': 'application/json',
        },
    };
    try {
        const response = await fetch(targetUrl, fetchOptions);
        if (!response.ok) {
            throw new Error(`Failed to fetch resource: ${response.statusText}`);
        }

        const responseBody = await response.text();
        return new Response(responseBody, {
            status: response.status,
            headers: response.headers,
        });
    } catch (error) {
        console.error('Error during proxy request:', error);
        return new Response(JSON.stringify({error: 'Failed to fetch resource'}), {
            status: 500,
        });
    }
}

export async function PATCH(request: NextRequest) {
    const loginPayload = await getJWT()
    if (!loginPayload) {
        return new Response(JSON.stringify({error: 'Token not found in cookies'}), {
            status: 401,
        });
    }

    const url = new URL(request.url);

    const originalUrl = `http://localhost:8080${url.pathname}${url.search}`;
    const targetUrl = originalUrl.toString().replace('/api/proxy', '');
    const res = await request.json()
    console.log(res)
    const fetchOptions: RequestInit = {
        method: request.method,
        headers: {
            'Authorization': `Bearer ${loginPayload.token}`,
            'Content-Type': 'application/json',
        },
        body:JSON.stringify(res),
        duplex: 'half'
    };
    try {
        const response = await fetch(targetUrl, fetchOptions);
        if (!response.ok) {
            throw new Error(`Failed to fetch resource: ${response.statusText}`);
        }
        const responseBody = await response.json();
        return new Response(responseBody, {
            status: response.status,
            headers: response.headers,
        });
    } catch (error) {
        console.error('Error during proxy request:', error);
        return new Response(JSON.stringify({error: 'Failed to fetch resource'}), {
            status: 500,
        });
    }
}