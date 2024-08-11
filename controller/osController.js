const os = require("os");
//get machine infos
module.exports.getOsInformation = (req, res) => {
  try {
    
    const osInformation ={
        hostname: os.hostname(),
        type: os.type(),
        platform: os.platform(),
    }
     if(!osInformation)
     {
        throw new Error("os not found !");
     }
    res.status(200).json(osInformation);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};
