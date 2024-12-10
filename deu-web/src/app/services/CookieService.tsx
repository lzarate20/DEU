import Cookies from "js-cookie";

interface Team{
    id:bigint;
    name:string;
}

interface User {
    id:bigint;
    name: string;
    email: string;
    type:string;
    teams:Array<Team>;
}

const CookieService = {
    setAuthToken: (token: string, expiresInDays = 7) => {
        Cookies.set("authToken", token, { expires: expiresInDays });
    },
    setUser: (user: User, expiresInDays = 7) => {
        Cookies.set("user", JSON.stringify(user), { expires: expiresInDays });
    },
    getAuthToken: () => {
        return Cookies.get("authToken") || null;
    },
    getUser: (): User | null => {
        const user = Cookies.get("user");
        return user ? JSON.parse(user) : null;
    },
    clearSession: () => {
        Cookies.remove("authToken");
        Cookies.remove("user");
    },
};

export default CookieService;