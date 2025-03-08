import React from 'react';
import Calendar from 'react-calendar';
import 'react-calendar/dist/Calendar.css';


const CustomCalendar = () => {
    return (
        <Calendar
            className="reactCalendar"
            locale="es"
        />
    );
}

export default CustomCalendar;