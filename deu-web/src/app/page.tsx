import React from "react";
import Link from "next/link";
import styles from './styles/Button.module.css';

export default function Home() {
  return (
      <div className="min-h-screen flex flex-col">
          <main className="flex-grow container mx-auto p-8">
              <div>
                  <Link href="/login">
                      <button className={styles.button}>Iniciar sesión</button>
                  </Link>
                  <Link href="/register">
                      <button className={styles.button}>Registrar cuenta</button>
                  </Link>
              </div>
          </main>
      </div>
  );
}
