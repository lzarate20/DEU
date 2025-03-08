"use client"

import { useState, useEffect } from 'react';
import Link from 'next/link';
import CookieService from "@/app/services/CookieService";
import {LetterSize, ThemeType} from "@/app/lib/definition";
import {patchConfig} from "@/app/services/ConfigService";
import {FaCheck} from "react-icons/fa";

const ProfileMenu = () => {
    const [isOpen, setIsOpen] = useState(false);
    const [submenu, setSubmenu] = useState("");
    const [mounted, setMounted] = useState(false);
    const [theme, setTheme] = useState<ThemeType>(ThemeType.DAY); // Usamos el enum como tipo
    const [fontSize, setFontSize] = useState<LetterSize>(LetterSize.SMALL);

    useEffect(() => {
        setMounted(true);
        const config = CookieService.getConfig();
        const theme = config?.theme || ThemeType.DAY;
        const fontSize = config?.letterSize || LetterSize.SMALL;
        setTheme(theme);
        setFontSize(fontSize);
    }, []);


    useEffect(() => {
        const handleClickOutside = (event: MouseEvent) => {
            if (event.target instanceof HTMLElement && !event.target.closest('.relative')) {
                setIsOpen(false);  // Cierra el menú principal
                setSubmenu("");  // Cierra cualquier submenú
            }
        };

        document.addEventListener('mousedown', handleClickOutside);

        return () => {
            document.removeEventListener('mousedown', handleClickOutside);
        };
    }, []);

    const updateConfigInDB = async (theme: ThemeType, fontSize: LetterSize) => {
        const userId = CookieService.getUser()?.id;
        patchConfig({ id:0,idUser:userId,theme:theme,letterSize:fontSize });

    };

    const toggleMenu = () => {
        if (isOpen) {
            setIsOpen(false);
        }
        else if(submenu != ""){
            setIsOpen(false);
            setSubmenu("")
        }
        else {
            setIsOpen(true);
        }
    };

    const openSubmenu = (menu: string) => {
        toggleMenu();
        setIsOpen(false);
        setSubmenu(menu);
    };


    const changeTheme = (newTheme: ThemeType) => {
        if (newTheme !== theme) {
            setTheme(newTheme); // Actualiza el tema en el estado
            setSubmenu(""); // Cierra el submenú
            CookieService.setConfig({theme: newTheme, letterSize: fontSize});
            updateConfigInDB(newTheme, fontSize);
        }
    };

    const changeFontSize = (size: LetterSize) => {
        if(size!= fontSize) {
            setFontSize(size);
            setSubmenu("");
            CookieService.setConfig({theme, letterSize: size});
            updateConfigInDB(theme, size);
        }
    };

    if (!mounted) {
        return null;
    }

    return (
        <div className="relative">
            <button
                onClick={toggleMenu}
                className="p-2 rounded-full hover:bg-gray-200"
                aria-expanded={isOpen}
                aria-controls="profile-menu"
            >
                <img
                    src="/icon/menus.png"
                    alt="Profile"
                    className="w-8 h-8 rounded-full"
                />
            </button>

            {isOpen && (
                <div
                    id="profile-menu"
                    className="absolute right-0 mt-2 bg-white shadow-lg rounded-md w-48"
                >
                    <ul className="space-y-2 p-2">
                        <li>
                            <button
                                onClick={() => openSubmenu("theme")}
                                className="block px-4 py-2 hover:bg-gray-100"
                            >
                                Tema
                            </button>
                        </li>
                        <li>
                            <button
                                onClick={() => openSubmenu("fontSize")}
                                className="block px-4 py-2 hover:bg-gray-100"
                            >
                                Tamaño de fuente
                            </button>
                        </li>
                        <li>
                            <Link href="/profile" className="block px-4 py-2 hover:bg-gray-100">
                                Perfil
                            </Link>
                        </li>
                    </ul>
                </div>
            )}

            {submenu === "theme" && (
                <div className="absolute right-0 mt-2 bg-white shadow-lg rounded-md w-48">
                    <ul className="space-y-2 p-2">
                        <li>
                            <button
                                onClick={() => changeTheme(ThemeType.DAY)}
                                className="block px-4 py-2 hover:bg-gray-100 flex items-center justify-start space-x-2"
                            >
                                {theme === ThemeType.DAY && <FaCheck className="text-blue-500"/>}
                                <span>Día</span>
                            </button>
                        </li>
                        <li>
                            <button
                                onClick={() => changeTheme(ThemeType.NIGHT)}
                                className="block px-4 py-2 hover:bg-gray-100 flex items-center justify-start space-x-2"
                            >
                                {theme === ThemeType.NIGHT && <FaCheck className="text-blue-500"/>}
                                <span>Noche</span>
                            </button>
                        </li>
                    </ul>
                </div>
            )}

            {submenu === "fontSize" && (
                <div className="absolute right-0 mt-2 bg-white shadow-lg rounded-md w-48">
                    <ul className="space-y-2 p-2">
                        <li>
                            <button
                                onClick={() => changeFontSize(LetterSize.SMALL)}
                                className="block px-4 py-2 hover:bg-gray-100 flex items-center justify-start space-x-2"
                            >
                                {fontSize === LetterSize.SMALL && <FaCheck className="text-blue-500"/>}
                                <span>Pequeño</span>
                            </button>
                        </li>
                        <li>
                            <button
                                onClick={() => changeFontSize(LetterSize.MEDIUM)}
                                className="block px-4 py-2 hover:bg-gray-100 flex items-center justify-start space-x-2"
                            >
                                {fontSize === LetterSize.MEDIUM && <FaCheck className="text-blue-500"/>}
                                <span>Mediano</span>
                            </button>
                        </li>
                        <li>
                            <button
                                onClick={() => changeFontSize(LetterSize.LARGE)}
                                className="block px-4 py-2 hover:bg-gray-100 flex items-center justify-start space-x-2"
                            >
                                {fontSize === LetterSize.LARGE && <FaCheck className="text-blue-500"/>}
                                <span>Grande</span>
                            </button>
                        </li>
                    </ul>
                </div>

            )}
        </div>
    );
};

export default ProfileMenu;

