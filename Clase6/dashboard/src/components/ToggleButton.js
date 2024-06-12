import React from 'react';

const ToggleButton = ({ backendUrl, endpoint, params, label }) => {
  const handleClick = (estados) => {
    fetch(`${backendUrl}/${endpoint}`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({ ...params, estado: estados }),
    })
      .then(response => {
        if (!response.ok) {
          throw new Error('Network response was not ok');
        }
        return response.json();
      })
      .then(data => console.log(data))
      .catch(error => console.error('There was a problem with the fetch operation:', error));
  };

  return (
    <div>
      <button onClick={() => handleClick(1)}>{`Activar ${label}`}</button>
      <button onClick={() => handleClick(0)}>{`Desactivar ${label}`}</button>
    </div>
  );
};

export default ToggleButton;
