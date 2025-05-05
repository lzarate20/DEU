import React from 'react';
import Calendar from 'react-calendar';
import 'react-calendar/dist/Calendar.css';

const CustomCalendar = ({ selectedDate, onDateChange }) => {
    return (
        <Calendar
            className="reactCalendar"
            locale="es"
            value={selectedDate}
            onChange={onDateChange}
        />
    );
};

export default CustomCalendar;