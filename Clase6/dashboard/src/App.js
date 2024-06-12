import React, { useState } from 'react';
import ToggleButton from './components/ToggleButton';
import StatusLabel from './components/StatusLabel';
import RoomSelector from './components/RoomSelector';
import MotorControl from './components/MotorControl';
import './App.css'; // Importa el archivo CSS

function App() {
  const [selectedRoom, setSelectedRoom] = useState(1);
  const backendUrl = 'http://10.109.1.118:5000'; // Variable centralizada para la dirección del backend

  return (
    <div className="App">
      <h1>Dashboard</h1>
      <div>
        <h2>Control LED</h2>
        <RoomSelector selectedRoom={selectedRoom} onRoomChange={setSelectedRoom} />
        <ToggleButton 
          backendUrl={backendUrl} 
          endpoint="activarLed" 
          params={{ cuarto: selectedRoom }} 
          label={`LED Cuarto ${selectedRoom}`} 
        />
        <StatusLabel 
          backendUrl={backendUrl} 
          endpoint="verEstadoLED" 
          queryParams={{ cuarto: Number(selectedRoom) }}
          extractStatus={(data) => data.estado}
        />
      </div>
      <div>
        <h2>Control Motor</h2>
        <MotorControl backendUrl={backendUrl} />
      </div>
    </div>
  );
}

export default App;
