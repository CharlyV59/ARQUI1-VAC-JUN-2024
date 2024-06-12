import React from 'react';

const RoomSelector = ({ selectedRoom, onRoomChange }) => {
  const rooms = Array.from({ length: 8 }, (_, i) => i + 1);

  return (
    <select value={selectedRoom} onChange={(e) => onRoomChange(Number(e.target.value))}>
      {rooms.map(room => (
        <option key={room} value={room}>{room}</option>
      ))}
    </select>
  );
};

export default RoomSelector;
