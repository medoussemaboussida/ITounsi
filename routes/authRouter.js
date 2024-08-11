var express = require('express');
var router = express.Router();
const authController = require('../controller/authController');
const authenticateToken = require('../middlewares/authMiddlewares'); // Assurez-vous d'avoir le bon chemin

/* GET users listing. */
router.get('/getAllUsers', authController.getAllUsers);
router.post('/addVisitor', authController.addVisitor);
router.post('/login', authController.login);
router.get('/profile', authenticateToken, authController.profile);

module.exports = router;
