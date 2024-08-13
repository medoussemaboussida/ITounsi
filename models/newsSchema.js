const mongoose = require("mongoose");

const newsSchema = new mongoose.Schema({

    category :{ type: String , required : true , enum:[ 'IOT', 'Cyber Security', 'AI' , 'Blockchain' , 'Data management and analytics' , 'Software development']},
    description :{ type: String , required : true },
    news_date: { type: Date,default: Date.now },
    news_photo: {type : String , required: true},
},
{
    timestamps:true
}
);


newsSchema.post("save", async function (req,res,next) {
    console.log("news created successfully");
    next();
});


const News = mongoose.model("News", newsSchema);

module.exports = News;