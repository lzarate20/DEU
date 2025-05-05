import React, { ChangeEventHandler, useContext } from "react";
import {ThemeType} from "@/app/lib/definition";



interface ThemeContextInterface {
    theme: ThemeType;
    toggleTheme: ChangeEventHandler<HTMLInputElement>
}

export const ThemeContext = React.createContext<ThemeContextInterface>({
    theme: ThemeType.DAY,
    toggleTheme: () => {},
});

export const useTheme: Function = () => {
    const context = useContext(ThemeContext)
    if(!context) {
        throw new Error(
            "useTheme must be used inside a ThemeContext.Provider"
        )
    }
    return context.theme
};