const jwt = require('jsonwebtoken');
require('dotenv');

// Middleware pour vérifier le jeton JWT
const authenticateToken = (req, res, next) => {
  // Récupère le jeton depuis les en-têtes de la requête
  const authHeader = req.headers['authorization'];
  const token = authHeader && authHeader.split(' ')[1]; // Exemple: 'Bearer <token>'

  if (token == null) return res.sendStatus(401); // Pas de jeton, accès non autorisé

  // Vérifie le jeton
  jwt.verify(token, 'your_jwt_secret', (err, user) => {
    if (err) return res.sendStatus(403); // Jeton invalide ou expiré
    req.user = user; // Ajoute les informations utilisateur à la requête
    next(); // Passe au middleware suivant ou à la route
  });
};

module.exports = authenticateToken;
