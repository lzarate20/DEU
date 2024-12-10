"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";
import CookieService from "@/app/services/CookieService";

function LoginForm() {
    const [email, setEmail] = useState("");
    const [password, setPassword] = useState("");
    const router = useRouter();

    const handleSubmit = async (e: { preventDefault: () => void; }) => {
        e.preventDefault();
        const response = await fetch("http://localhost:8080/api/auth", {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({ email, password }),
        });

        const data = await response.json();
        if (response.ok) {
            CookieService.setAuthToken(data.token);
            CookieService.setUser(data.user);
            console.log("Login exitoso:", data);
            router.push("/");
        } else {
            console.error("Error en el login:", data.message);
        }
    };

    return (
        <form onSubmit={handleSubmit}>
            <div>
                <label>Email:</label>
                <input
                    type="email"
                    value={email}
                    onChange={(e) => setEmail(e.target.value)}
                    required
                />
            </div>
            <div>
                <label>Contraseña:</label>
                <input
                    type="password"
                    value={password}
                    onChange={(e) => setPassword(e.target.value)}
                    required
                />
            </div>
            <button type="submit">Iniciar sesión</button>
        </form>
    );
}

export default LoginForm;