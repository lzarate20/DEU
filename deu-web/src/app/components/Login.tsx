"use client";

import CookieService from "@/app/services/CookieService";
import { useState } from "react";
import { useRouter } from "next/navigation";
import {getConfig} from "@/app/services/ConfigService";

function LoginForm() {
    const [email, setEmail] = useState("");
    const [password, setPassword] = useState("");
    const router = useRouter();

    const handleSubmit = async (e: { preventDefault: () => void; }) => {
        e.preventDefault();
        const response = await fetch("/api/login", {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({ email, password }),
        });
        const data = await response.json();
        if (response.ok) {
            console.log("Login exitoso:", data);
            CookieService.setUser(data.user)
            const configData = await getConfig(data.user.id)
            CookieService.setConfig(configData);
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