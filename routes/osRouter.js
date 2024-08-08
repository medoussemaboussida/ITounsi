var express = require('express');
var router = express.Router();
const osController = require('../controller/osController');

/* GET users listing. */
router.get('/getInformation', osController.message);

module.exports = router;
