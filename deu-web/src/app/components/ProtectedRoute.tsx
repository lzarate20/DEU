"use client";

import { useEffect, useState } from "react";
import { useRouter, usePathname } from "next/navigation";
import CookieService from "@/app/services/CookieService";

interface ProtectedRouteProps {
    component: React.ReactNode;
    roles?: string[];
}

const ProtectedRoute = ({ component, roles }: ProtectedRouteProps) => {
    const router = useRouter();
    const [isLoading, setIsLoading] = useState(true);
    const pathname = usePathname()
    const token = CookieService.getAuthToken();
    const user = CookieService.getUser();

    useEffect(() => {
        if (!user || !token) {
            if(pathname != "/") {
                router.push("/");
            }
        } else if (roles && !roles.includes(user.type)) {
            if(pathname != "/") {
                router.push("/");
            }
        }
        setIsLoading(false);
    }, [user, token, roles, router]);

    if (isLoading) {
        return null;
    }

    if (user && token && (roles && roles.includes(user.type.toLowerCase()))) {
        return <>{component}</>;
    }

    return null; // Si no cumple con las condiciones, no renderiza nada
};

export default ProtectedRoute;