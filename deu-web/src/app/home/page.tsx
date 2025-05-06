'use client'; // si usas Next.js App Router

import React, {useEffect, useState} from 'react';
import MyTeams from "@/app/components/MyTeams";
import MyTrainings from "@/app/components/MyTrainings";
import CustomCalendar from "@/app/components/Calendar";

export default function Page() {
    const [selectedDate, setSelectedDate] = useState(() => {
        const storedDate = sessionStorage.getItem("selectedDate");
        return storedDate ? new Date(storedDate) : new Date();
    });

    useEffect(() => {
        sessionStorage.setItem("selectedDate", selectedDate.toISOString());
    }, [selectedDate]);


    return (
        <div className="min-h-screen flex flex-col">
            <main className="flex-grow container mx-auto p-8">
                <div className="flex flex-row space-x-4">
                    <div className="w-1/3 bg-white-100 p-4 rounded">
                        <MyTeams/>
                    </div>

                    <div className="w-1/3 bg-white-100 p-4 rounded">
                        <MyTrainings selectedDate={selectedDate}/>
                    </div>

                    <div className="w-1/3 bg-white-100 p-4 rounded">
                        <CustomCalendar
                            selectedDate={selectedDate}
                            onDateChange={setSelectedDate}
                        />
                    </div>
                </div>
            </main>
        </div>
    );
}