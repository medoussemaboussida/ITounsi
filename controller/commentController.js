const commentModel = require('../models/commentSchema');
const newsModel = require('../models/newsSchema');

module.exports.addComment = async (req, res) => {
    try {
        const { newsId } = req.params; // Récupère l'ID de la news depuis l'URL
        const { commentText } = req.body; // Récupère le texte du commentaire depuis le corps de la requête
        const userId = req.user.userId; // Utilisateur connecté, récupéré via le middleware authenticateToken

        // Vérifiez si la news existe
        const news = await newsModel.findById(newsId);
        if (!news) {
            return res.status(404).json({ message: 'News not found' });
        }

        // Créez un nouveau commentaire
        const comment = new commentModel({
            userId: userId,
            newsId: newsId,
            commentText
        });

        // Sauvegardez le commentaire
        const savedComment = await comment.save();

        res.status(201).json(savedComment);
    } catch (err) {
        res.status(500).json({ message: err.message });
    }
};

//read
module.exports.getAllComments = async (req, res) => { 
    try {
        const { newsId } = req.params;

       
        const news = await newsModel.findById(newsId);
        if (!news) {
            return res.status(404).json({ message: 'News not found' });
        }

        // Trouver tous les commentaires pour cette news avec les détails de l'utilisateur
        const comments = await commentModel.find({ newsId }).populate({
            path: 'userId',
            select: 'username' // Spécifie les champs à inclure, par exemple, 'username'
        });
        res.status(200).json({ comments });
    } catch (err) {
        res.status(500).json({ message: err.message });
    }
};

/*//read connected user comments
module.exports.getCommentsByUser = async (req, res) => {
    try {
        const userId = req.user.userId; // Utilisateur connecté, récupéré via le middleware authenticateToken

        // Récupère tous les commentaires pour cet utilisateur
        const userComments = await commentModel.find({ userId: userId });

        // Si aucun commentaire n'est trouvé
        if (userComments.length === 0) {
            return res.status(404).json({ message: 'No comments found for this user' });
        }

        res.status(200).json(userComments);
    } catch (err) {
        res.status(500).json({ message: err.message });
    }
};
*/
module.exports.deleteComment = async (req,res)=>{
    try{
        console.log(req.params);
        const {id} = req.params

        const check = await commentModel.findById(id);
        if(!check)
        {
            throw new Error("comment not found here!");
        }
        const comment = await commentModel.findByIdAndDelete(id);
        res.status(200).json({comment});
    }catch(err){
        res.status(500).json({message: err.message})
    }
};