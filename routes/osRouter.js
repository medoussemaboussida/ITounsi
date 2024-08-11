var express = require("express");
var router = express.Router();
const osController = require("../controller/osController");

/* GET users listing. */
router.get("/getInformation", osController.getOsInformation); //my machine infos

module.exports = router;
