import React, { useEffect, useState } from 'react';

function App() {
  const [messageBack, setMessageBack] = useState("Chargement...");
  
  // Utilise ton URL de backend
  const BACKEND_URL = "https://flask-render-iac-steeveparis-4zeu.onrender.com";

  useEffect(() => {
    // On appelle la racine "/" pour avoir la chaîne de caractères
    fetch(`${BACKEND_URL}/`)
      .then(res => res.text()) // .text() car c'est une chaîne simple, pas du JSON
      .then(data => {
        setMessageBack(data);
      })
      .catch(err => {
        console.error(err);
        setMessageBack("Erreur de connexion au backend");
      });
  }, []);

  return (
    <div style={{ textAlign: 'center', marginTop: '100px', fontFamily: 'Arial' }}>
      <h1>Mon Projet Fullstack</h1>
      <div style={{ padding: '20px', border: '1px solid #007bff', display: 'inline-block', borderRadius: '10px' }}>
        <h3>Message reçu du Backend :</h3>
        <p style={{ fontSize: '20px', color: '#007bff' }}>{messageBack}</p>
      </div>
    </div>
  );
}

export default App;
