const mongoose = require("mongoose");
const bcrypt = require("bcrypt"); 

const userSchema = new mongoose.Schema({

    username :{ type: String , required : false , unique : true},
    dob: { type: Date, required: false },
    email :{ type: String , required : true , unique : true},
    password: { type: String , required : true},
    role: { type: String , enum:[ 'admin', 'visitor'] , required : false},
    user_photo: {type : String , required: false},
    etat: {type : String , default:'Actif',required: false},
    
},
{
    timestamps:true
}
);


userSchema.post("save", async function (req,res,next) {
    console.log("user created successfully");
    next();
});

userSchema.pre("save", async function (next) {
    try{
        const salt = await bcrypt.genSalt();
        const User = this;
        User.password = await bcrypt.hash(User.password,salt);
        next();
    }catch (err)
    {
        next(err);
    }
});
const User = mongoose.model("User", userSchema);

module.exports = User;