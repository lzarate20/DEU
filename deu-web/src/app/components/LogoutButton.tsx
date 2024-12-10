"use client";

import CookieService from "@/app/services/CookieService";
import {useRouter} from "next/navigation";

function LogoutButton() {
    const router = useRouter();
    const handleLogout = () => {
        CookieService.clearSession();
        router.push("/")
    };

    return <button onClick={handleLogout}>Cerrar sesión</button>;
}

export default LogoutButton;