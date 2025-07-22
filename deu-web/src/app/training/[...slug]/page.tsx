"use client";

import { useEffect, useState } from "react";

export default function TrainingDetailPage() {
    const [training, setTraining] = useState(null);
    const [selectedVideo, setSelectedVideo] = useState(null);

    useEffect(() => {
        const stored = sessionStorage.getItem("selectedTraining");
        if (stored) {
            const trainingData = JSON.parse(stored);
            setTraining(trainingData);
            setSelectedVideo(trainingData.exercises?.[0]?.url || null);
        }
    }, []);

    if (!training) {
        return <div className="p-8 text-gray-500">Cargando entrenamiento...</div>;
    }

    return (
        <div className="flex h-screen p-8 gap-6">
            {/* Listado lateral de ejercicios */}
            <div className="w-64 overflow-y-auto">
                <h2 className="text-xl font-bold mb-4">Ejercicios</h2>
                <div className="flex flex-col gap-4">
                    {training.exercises?.map((exercise, index) => (
                        <div
                            key={index}
                            className={`border rounded-xl p-3 shadow cursor-pointer bg-white hover:bg-gray-100 transition ${
                                selectedVideo === exercise.videoUrl ? "ring-2 ring-blue-400" : ""
                            }`}
                            onClick={() => setSelectedVideo(exercise.url)}
                        >
                            <img
                                src="/icon/video.png"
                                alt="video"
                                className="w-8 h-8 rounded-full"
                            />
                            <h3 className="text-sm font-semibold">{exercise.title}</h3>
                            <p className="text-xs text-gray-500">{exercise.reps}</p>
                        </div>
                    ))}
                </div>
            </div>

            {/* Video principal centrado */}
            <div className="flex-1 flex items-start justify">
                {selectedVideo && (
                    <div className="flex-1 flex items-center justify-center">
                        <div className="w-full max-w-6xl aspect-video">
                            <p className="mb-2 text-sm text-gray-500">Video URL: {selectedVideo}</p>
                            <iframe
                                key={selectedVideo}
                                src={selectedVideo}
                                className="w-full h-full rounded-xl shadow-lg"
                                allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture"
                                allowFullScreen
                            />
                        </div>
                    </div>
                )}
            </div>
        </div>
    );
}
