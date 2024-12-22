import React from 'react';
import Header from "@/app/header";
import Footer from "@/app/footer";
import LoginForm from "@/app/components/Login";

export default function Page() {
    return (
        <>
            <div className="min-h-screen flex flex-col">
                <Header/>
                <main className="flex-grow container mx-auto p-8">
                    <LoginForm/>
                </main>
                <Footer/>
            </div>
        </>
    )
}