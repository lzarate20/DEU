"use client";
import React, { useEffect, useState } from "react";
import {LetterSize, ThemeType} from "@/app/lib/definition";
import CookieService from "@/app/services/CookieService";
import {patchConfig} from "@/app/services/ConfigService";
import {ThemeContext} from "@/app/components/theme/ThemeContext";


type Props = {
    children?: React.ReactNode;
};

const ThemeProvider: React.FC<Props> = ({ children }) => {

    const updateConfigInDB = async (theme: ThemeType, fontSize: LetterSize) => {
        const userId = CookieService.getUser()?.id;
        patchConfig({ id:0,idUser:userId,theme:theme,letterSize:fontSize });

    };

    const [theme, setTheme] = useState<ThemeType>(ThemeType.DAY);
    const [letterSize, setLetterSize] = useState<LetterSize>(LetterSize.SMALL);

    const toggleTheme = (): void => {
        const newTheme = theme == ThemeType.NIGHT ? ThemeType.DAY : ThemeType.NIGHT;
        setTheme(newTheme);
        document.documentElement.setAttribute("data-theme", newTheme);
        CookieService.setConfig({theme: newTheme, letterSize: letterSize});
        updateConfigInDB(newTheme, letterSize);
    };

    const contextValue = {
        theme: theme,
        toggleTheme: toggleTheme,
    };

    useEffect(() => {
        const system: ThemeType =
            (CookieService.getConfig()?.theme) ??
            (window.matchMedia &&
            window.matchMedia("(prefers-color-scheme: dark)").matches
                ? ThemeType.NIGHT
                : ThemeType.DAY);
        document.documentElement.setAttribute("data-theme", system);
        const config = CookieService.getConfig();
        const theme = config?.theme || ThemeType.DAY;
        const fontSize = config?.letterSize || LetterSize.SMALL;
        setTheme(theme);
        setLetterSize(fontSize);
    }, []);


    return (
        <ThemeContext.Provider value={contextValue}>{children}</ThemeContext.Provider>
    );
};

export default ThemeProvider;