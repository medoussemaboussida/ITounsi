const mongoose = require('mongoose');

module.exports.connectToMongoDB = async () =>  {
    mongoose.set('strictQuery',false);
    mongoose.connect(process.env.URl_MONGO).then(
        ()=>{console.log('connect to DB');
        })
        .catch((err)=>{console.log(err)});

};