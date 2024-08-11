const mongoose = require('mongoose');

//connecting with mongo dataBase
module.exports.connectToMongoDB = async () =>  {
    mongoose.set('strictQuery',false);
    mongoose.connect(process.env.URl_MONGO).then(
        ()=>{console.log('connect to DB');
        })
        .catch((err)=>{console.log(err)});

};