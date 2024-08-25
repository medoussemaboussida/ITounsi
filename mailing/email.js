const nodemailer = require('nodemailer');
require('dotenv').config(); // Assure-toi que tes variables d'environnement sont chargées

// Configuration du transporteur avec Gmail
const transporter = nodemailer.createTransport({
  service: 'gmail',
  auth: {
    user: process.env.EMAIL_USER, // Ton adresse email
    pass: process.env.EMAIL_PASS, // Ton mot de passe ou App Password (si 2FA est activé)
  },
});

// Vérification de la configuration
transporter.verify(function (error, success) {
  if (error) {
    console.log('Erreur de configuration du mail:', error);
  } else {
    console.log("Le serveur de mail est prêt pour envoyer des messages");
  }
});

module.exports = transporter;
