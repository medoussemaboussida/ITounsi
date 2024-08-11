const jwt = require('jsonwebtoken');
const User = require('../models/userSchema'); // Assurez-vous que le chemin est correct

// Middleware pour vérifier le token JWT
const authenticateToken = (req, res, next) => {
    const authHeader = req.headers['authorization'];
    const token = authHeader && authHeader.split(' ')[1]; // Extraction du token

    if (token == null) {
        console.error('No token provided'); // Log si aucun token n'est fourni
        return res.status(401).json({ message: 'Token missing' }); // Erreur 401 si le token est manquant
    }

    jwt.verify(token, process.env.SECRET_KEY, (err, user) => {
        if (err) {
            console.error('Token verification failed:', err); // Log si la vérification du token échoue
            return res.status(403).json({ message: 'Forbidden' }); // Erreur 403 si le token est invalide
        }
        req.user = user;
        next();
    });
};

module.exports = authenticateToken;
