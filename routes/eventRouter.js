var express = require('express');
var router = express.Router();
const eventController = require('../controller/eventController');
const upload = require("../middlewares/uploadFIle");
/* GET users listing. */
router.get('/getEvent', eventController.getEvent);
router.post('/addEvent',upload.single("event_photo"),eventController.addEvent);
router.delete('/deleteEvent/:id', eventController.deleteEvent);
router.get('/getEventById/:id', eventController.getEventById);
router.put('/updateEvent/:id',upload.single("news_photo"),eventController.updateEvent);
module.exports = router;
