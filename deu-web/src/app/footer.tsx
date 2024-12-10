import React from "react";

const Footer = () => {
    return (
        <footer className="bg-gray-800 text-white py-6 mt-8">
            <div className="container mx-auto text-center">
                <p>&copy; 2024 Mi Aplicación. Todos los derechos reservados.</p>
                <div className="mt-4">
                    <a href="/privacy" className="hover:text-gray-400">Política de privacidad</a>
                    <span className="mx-2">|</span>
                    <a href="/terms" className="hover:text-gray-400">Términos y condiciones</a>
                </div>
            </div>
        </footer>
    );
};

export default Footer;