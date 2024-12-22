import React from 'react';
import MyTeams from "@/app/components/MyTeams";
import MyTrainings from "@/app/components/MyTrainings";
import CustomCalendar from "@/app/components/Calendar";


export default function Page() {
    return (
        <>
            <div className="min-h-screen flex flex-col">
                <main className="flex-grow container mx-auto p-8">
                    <div className="flex flex-row space-x-4">
                        <div className="w-1/3 bg-white-100 p-4 rounded ">
                            <MyTeams/>
                        </div>

                        <div className="w-1/3 bg-white-100 p-4 rounded">
                            <MyTrainings/>
                        </div>
                        <div className="w-1/3 bg-white-100 p-4 rounded ">
                            <CustomCalendar/>
                        </div>
                    </div>
                </main>
            </div>
        </>
    )
}