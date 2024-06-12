import React, { useState, useEffect } from 'react';

const StatusLabel = ({ backendUrl, endpoint, queryParams, extractStatus }) => {
  const [status, setStatus] = useState(null);

  useEffect(() => {
    fetch(`${backendUrl}/${endpoint}?${new URLSearchParams(queryParams)}`)
      .then(response => {
        if (!response.ok) {
          throw new Error('Network response was not ok');
        }
        return response.json();
      })
      .then(data => {
            var jsonParceo = data;
            console.log(jsonParceo);
            console.log(jsonParceo);
            setStatus(extractStatus(data));
      })
      .catch(error => console.error('There was a problem with the fetch operation:', error));
  }, [backendUrl, endpoint, queryParams]);

  return (
    <label>{status !== null ? `Estado: ${status}` : 'Cargando...'}</label>
  );
};

export default StatusLabel;
