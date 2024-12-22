"use client";

import {useRouter} from "next/navigation";

function LogoutButton() {
    const router = useRouter();
    const handleLogout = () => fetch("/api/logout", {
        method: "POST",
        headers: { "Content-Type": "application/json" }
    });

    return <button onClick={handleLogout}>Cerrar sesión</button>;
}

export default LogoutButton;