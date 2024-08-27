var express = require('express');
var router = express.Router();
const authController = require('../controller/authController');
const authenticateToken = require('../middlewares/authMiddlewares'); // Assurez-vous d'avoir le bon chemin
const upload = require("../middlewares/uploadFIle");

/* GET users listing. */
router.get('/getAllUsers', authController.getAllUsers);
router.post('/addVisitor', authController.addVisitor);
router.post('/addAdmin', authController.addAdmin);
router.post('/login', authController.login);
router.get('/profile', authenticateToken, authController.profile);
router.put('/updateProfile',authenticateToken,upload.single("user_photo"),authController.updateProfile);
router.post('/send-code', authController.sendVerificationCode);
router.post('/verify-code', authController.verifyCodeAndLogin);
router.put('/updateMdp',authenticateToken,authController.updateMdp);

module.exports = router;
