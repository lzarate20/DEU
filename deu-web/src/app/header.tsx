import React from "react";
import ProtectedRoute from "@/app/components/ProtectedRoute";
import LogoutButton from "@/app/components/LogoutButton";

const Header = () => {
    return (
        <header className="header">
            <div className="container mx-auto flex justify-between items-center">
                <h1 className="header__title">Mi Aplicación</h1>
                <nav>
                    <ul className="header__nav">
                        <li><a href="/public" className="header__link">Inicio</a></li>
                        <li><a href="/about" className="header__link">Acerca de</a></li>
                        <li><a href="/contact" className="header__link">Contacto</a></li>
                        <ProtectedRoute component=<LogoutButton/> roles={['trainee', 'trainer']}/>
                    </ul>
                </nav>
            </div>
        </header>
    );
};

export default Header;