var express = require('express');
var router = express.Router();
const commentController = require('../controller/commentController');
const authenticateToken = require('../middlewares/authMiddlewares'); // Assurez-vous d'avoir le bon chemin

router.post('/addComment/:newsId',authenticateToken,commentController.addComment);
router.get('/getAllComments/:newsId',commentController.getAllComments);
router.delete('/deleteComment/:id', commentController.deleteComment);

module.exports = router;
