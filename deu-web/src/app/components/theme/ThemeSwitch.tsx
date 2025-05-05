"use client";

import { ThemeContext } from "@/app/components/theme/ThemeContext";
import { MoonIcon } from "@heroicons/react/24/outline";
import { SunIcon } from "@heroicons/react/24/outline";
import React from "react";
import { ThemeType } from "@/app/lib/definition";

interface ThemeSwitcherProps {
    onClick?: () => void;
}

const ThemeSwitcher: React.FC<ThemeSwitcherProps> = ({ onClick }) => {
    const handleClick = (toggleTheme: () => void) => {
        toggleTheme();
        console.log("El tema fue cambiado");

        if (onClick) {
            onClick();
        }
    };

    return (
        <ThemeContext.Consumer>
            {({ theme, toggleTheme }) => (
                <div className="flex flex-col items-center space-y-6">
                    <div className="flex items-center cursor-pointer">
                        <MoonIcon
                            className={`h-10 w-10 ${theme === ThemeType.NIGHT ? 'text-blue-500' : 'text-gray-500'}`}
                            onClick={() => theme === ThemeType.DAY && handleClick(toggleTheme)}
                        />
                        <span className={`${theme === ThemeType.NIGHT ? 'text-blue-500' : 'text-gray-500'} mt-2`}>
              Noche
            </span>
                    </div>
                    <div className="flex items-center cursor-pointer">
                        <SunIcon
                            className={`h-10 w-10 ${theme === ThemeType.DAY ? 'text-yellow-500' : 'text-gray-500'}`}
                            onClick={() => theme === ThemeType.NIGHT && handleClick(toggleTheme)}
                        />
                        <span className={`${theme === ThemeType.DAY ? 'text-yellow-500' : 'text-gray-500'} mt-2`}>
              Día
            </span>
                    </div>
                </div>
            )}
        </ThemeContext.Consumer>
    );
};

export default ThemeSwitcher;





