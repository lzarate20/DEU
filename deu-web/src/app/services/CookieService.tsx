import Cookies from "js-cookie";
import {NextRequest} from "next/server";
import {ConfigData, User} from "@/app/lib/definition"

const CookieService = {
    setUser: (user: User, expiresInDays = 1) => {
        Cookies.set("user", JSON.stringify(user), {expires: expiresInDays});
    },
    getUser: (): User | null => {
        const user = Cookies.get("user");
        return user ? JSON.parse(user) : null;
    },
    setConfig:(config:ConfigData, expiresInDays = 1)=>{
        Cookies.set("conf", JSON.stringify(config), {expires: expiresInDays});
    },
    getConfig: (): ConfigData | null => {
        const conf = Cookies.get("conf");
        return conf ? JSON.parse(conf) : null;
    }
};
export function getAuthToken(req: NextRequest): string | null {
    const tokens = req.cookies.get('authToken')?.value;
    if (!tokens) return null;
    return tokens
}

export default CookieService;