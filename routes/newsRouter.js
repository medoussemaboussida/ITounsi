var express = require('express');
var router = express.Router();
const newsController = require('../controller/newsController');
const upload = require("../middlewares/uploadFIle");
/* GET users listing. */
router.get('/getNews', newsController.getNews);
router.post('/addNews',upload.single("news_photo"),newsController.addNews);
router.delete('/deleteNews/:id', newsController.deleteNews);
router.get('/getNewsById/:id', newsController.getNewsById);
router.put('/updateNews/:id',upload.single("news_photo"),newsController.updateNews);
router.get('/getNewsByCategory/:category', newsController.getNewsByCategory);
module.exports = router;
