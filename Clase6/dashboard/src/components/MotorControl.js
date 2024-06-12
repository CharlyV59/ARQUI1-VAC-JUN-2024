import React from 'react';
import ToggleButton from './ToggleButton';
import StatusLabel from './StatusLabel';

const MotorControl = ({ backendUrl }) => {
  return (
    <div>
      <ToggleButton 
        backendUrl={backendUrl}
        endpoint="activarMotor" 
        params={{}} 
        label="Motor"
      />
      <StatusLabel 
        backendUrl={backendUrl}
        endpoint="verEstadoMotor" 
        extractStatus={(data) => data.estado_motor}
      />
    </div>
  );
};

export default MotorControl;
