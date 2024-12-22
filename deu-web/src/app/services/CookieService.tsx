import Cookies from "js-cookie";
import {NextRequest} from "next/server";
import {User} from "@/app/lib/definition"

const CookieService = {
    setUser: (user: User, expiresInDays = 1) => {
        Cookies.set("user", JSON.stringify(user), {expires: expiresInDays});
    },
    getUser: (): User | null => {
        const user = Cookies.get("user");
        return user ? JSON.parse(user) : null;
    }
};
export function getAuthToken(req: NextRequest): string | null {
    const tokens = req.cookies.get('authToken')?.value;
    if (!tokens) return null;
    return tokens
}

export default CookieService;