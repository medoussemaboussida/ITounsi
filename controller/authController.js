const userModel = require('../models/userSchema');
const bcrypt = require("bcrypt"); 
const jwt = require('jsonwebtoken');

module.exports.getAllUsers = async (req,res) => { 

    try{
        const usersList = await userModel.find()
        res.status(200).json({usersList})
    }catch(err){
        res.status(500).json({message: err.message})
    }
}

//signup
module.exports.addVisitor = async (req,res) => { 

    try{
        console.log(req.body);
        const{ username , dob , email , password }=req.body;
        const roleVisitor = "visitor"
        const etatUser = "Actif"
        const photoUser= "Null"
        const user = new userModel({username , email , dob , password , role: roleVisitor , etat:etatUser , user_photo:photoUser});
        const userAdded = await user.save()
        res.status(201).json(userAdded);
    }catch(err){
        res.status(500).json({message: err.message})
    }
}
module.exports.login = async (req, res) => {
    try {
        const { email, password } = req.body;

        // Trouver l'utilisateur par email
        const user = await userModel.findOne({ email });

        // Vérifier si l'utilisateur existe
        if (!user) {
            return res.status(400).json({ message: 'User not found' });
        }

        // Comparer le mot de passe fourni avec le mot de passe haché stocké dans la base de données
        const isMatch = await bcrypt.compare(password, user.password);
        if (!isMatch) {
            return res.status(400).json({ message: 'Invalid email or password' });
        }

        // Générer un token JWT
        const token = jwt.sign(
            { userId: user._id }, // Payload
            process.env.SECRET_KEY, // Clé secrète
            { expiresIn: '30d' } // Expiration du token
        );

        // Répondre avec le token
        res.status(200).json({ token });
    } catch (err) {
        res.status(500).json({ message: err.message });
    }
};

// Méthode pour obtenir les informations du profil
module.exports.profile = async (req, res) => {
    try {
        if (!req.user || !req.user.userId) {
            return res.status(400).json({ message: 'Invalid request' });
        }

        // Trouver l'utilisateur par ID
        const user = await userModel.findById(req.user.userId);

        // Vérifier si l'utilisateur existe
        if (!user) {
            return res.status(404).json({ message: 'User not found' });
        }

        // Exclure le mot de passe des données renvoyées
        const { password, ...userData } = user._doc;

        // Répondre avec les données de l'utilisateur
        res.status(200).json(userData);
    } catch (err) {
        console.error('Error fetching user profile:', err);
        res.status(500).json({ message: 'Internal Server Error' });
    }
};