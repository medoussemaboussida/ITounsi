var express = require('express');
var router = express.Router();
const authController = require('../controller/authController');
const authenticateToken = require('../middlewares/authMiddlewares'); // Assurez-vous d'avoir le bon chemin
const upload = require("../middlewares/uploadFIle");

/* GET users listing. */
router.get('/getAllUsers', authController.getAllUsers);
router.post('/addVisitor', authController.addVisitor);
router.post('/login', authController.login);
router.get('/profile', authenticateToken, authController.profile);
router.put('/updateProfile',authenticateToken,upload.single("user_photo"),authController.updateProfile);
module.exports = router;
