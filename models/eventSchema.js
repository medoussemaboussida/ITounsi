const mongoose = require("mongoose");

const eventSchema = new mongoose.Schema({

    title :{ type: String , required : true },
    event_description :{ type: String , required : true },
    event_date: { type: Date, required : true},
    place :{ type: String , required : true },
    event_photo: {type : String , required: true},
},
{
    timestamps:true
}
);


eventSchema.post("save", async function (req,res,next) {
    console.log("event created successfully");
    next();
});


const Event = mongoose.model("Event", eventSchema);

module.exports = Event;