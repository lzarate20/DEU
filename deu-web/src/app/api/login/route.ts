import {NextRequest, NextResponse} from "next/server";
import { createSession } from '@/app/lib/session'

export async function POST(req: NextRequest) {
    const {email, password} = await req.json();

    try {
        const response = await fetch('http://localhost:8080/api/auth', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({email, password}),
        });

        if (!response.ok) {
            const errorData = await response.json();
            return NextResponse.json(
                {message: errorData.message || 'Authentication failed'},
                {status: response.status}
            );
        }

        const {token,user,expirationDate} = await response.json();

        // Configura el token en una cookie HttpOnly
        const res = NextResponse.json({user: user});
        await createSession(user.email,token,expirationDate)

        return res;
    } catch (error) {
        console.error('Error authenticating:', error);
        return NextResponse.json(
            {message: 'An error occurred, please try again later'},
            {status: 500}
        );
    }
}