const mongoose = require('mongoose');

// Schéma des commentaires
const commentSchema = new mongoose.Schema({
    userId: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'User',  // Référence au modèle utilisateur
        required: true
    },
    newsId: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'News',  // Référence au modèle news
        required: true
    },
    commentText: {
        type: String,
        required: true
    },
    commentDate: {
        type: Date,
        default: Date.now
    }
}, {
    timestamps: true
});


commentSchema.post("save", async function (req,res,next) {
    console.log("comment created successfully");
    next();
});



const Comment = mongoose.model('Comment', commentSchema);

module.exports = Comment;
