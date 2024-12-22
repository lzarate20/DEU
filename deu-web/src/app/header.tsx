import React from "react";
import Image from 'next/image';

const Header = () => {
    return (
        <header className="bg-gray-800 text-white w-1/16 h-screen p-4 flex flex-col fixed top-0 left-0">
            <nav>
                <ul className="space-y-2">
                    <li>
                        <a href="/home" className="hover:text-gray-300"><Image width={30} height={30}
                                                                               src="/icon/home.png"></Image></a>
                    </li>
                    <li>
                        <a href="/about" className="hover:text-gray-300">Acerca de</a>
                    </li>
                </ul>
            </nav>
        </header>
    );
};

export default Header;