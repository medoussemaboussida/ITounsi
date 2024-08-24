const userModel = require('../models/userSchema');
const bcrypt = require("bcrypt"); 
const jwt = require('jsonwebtoken');
const transporter = require("../mailing/email")
const sendVerificationEmail = require('../mailing/sendVerificationEmail');

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
            { userId: user._id, role: user.role }, // Payload
            process.env.SECRET_KEY, // Clé secrète
            { expiresIn: '30d' } // Expiration du token
        );

        // Répondre avec le token
        res.status(200).json({ token, role: user.role });
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

module.exports.updateProfile = async (req, res) => {
    try {
        if (!req.user || !req.user.userId) {
            return res.status(400).json({ message: 'Invalid request' });
        }

        const { username, dob } = req.body;
        const userPhoto = req.file ? req.file.filename : null;

        // Trouver l'utilisateur par ID
        const user = await userModel.findById(req.user.userId);

        // Vérifier si l'utilisateur existe
        if (!user) {
            return res.status(404).json({ message: 'User not found' });
        }

        // Préparer les champs à mettre à jour
        const updateFields = {};
        if (username) updateFields.username = username;
        if (dob) updateFields.dob = dob; // Hash le nouveau mot de passe si fourni
        if (userPhoto) updateFields.user_photo = userPhoto;

        // Mettre à jour les informations de l'utilisateur
        const updatedUser = await userModel.findByIdAndUpdate(req.user.userId, {
            $set: updateFields
        }, { new: true });

        // Vérifiez si la mise à jour a réussi
        if (!updatedUser) {
            return res.status(500).json({ message: 'Failed to update user' });
        }

        // Retourner les données de l'utilisateur mises à jour
        res.status(200).json(updatedUser);
    } catch (err) {
        console.error('Error updating user profile:', err);
        res.status(500).json({ message: err.message });
    }
};


//mdp update

module.exports.updateMdp = async (req, res) => {
    try {
        if (!req.user || !req.user.userId) {
            return res.status(400).json({ message: 'Invalid request' });
        }

        const { password } = req.body;

        // Vérifier si un mot de passe est fourni
        if (!password) {
            return res.status(400).json({ message: 'Password is required' });
        }

        // Trouver l'utilisateur par ID
        const user = await userModel.findById(req.user.userId);

        // Vérifier si l'utilisateur existe
        if (!user) {
            return res.status(404).json({ message: 'User not found' });
        }

        // Hacher le nouveau mot de passe
        const hashedPassword = await bcrypt.hash(password, 10);

        // Préparer les champs à mettre à jour
        const updateFields = { password: hashedPassword };

        // Mettre à jour les informations de l'utilisateur
        const updatedUser = await userModel.findByIdAndUpdate(req.user.userId, {
            $set: updateFields
        }, { new: true });

        // Vérifier si la mise à jour a réussi
        if (!updatedUser) {
            return res.status(500).json({ message: 'Failed to update password' });
        }

      
        res.status(200).json(userData);
    } catch (err) {
        console.error('Error updating user password:', err);
        res.status(500).json({ message: err.message });
    }
};


const verificationCodes = {}; // Stockage temporaire des codes de vérification
module.exports.sendVerificationCode = async (req, res) => {
    try {
        const { email } = req.body;

        // Vérifiez que l'e-mail est fourni
        if (!email) {
            return res.status(400).json({ message: 'Email is required' });
        }

        // Trouver l'utilisateur par e-mail
        const user = await userModel.findOne({ email });

        // Vérifier si l'utilisateur existe
     /*   if (!user) {
            return res.status(404).json({ message: 'User not found' });
        }*/

        // Générer un code de vérification
        const verificationCode = Math.floor(100000 + Math.random() * 900000).toString(); // Code à 6 chiffres

        // Stocker le code dans l'objet de stockage temporaire
        verificationCodes[email] = verificationCode;

        // Envoyer le code par e-mail
        await sendVerificationEmail(email, verificationCode);

        res.status(200).json({ message: 'Verification code sent' });
    } catch (err) {
        console.error('Error sending verification code:', err.message || err);
        res.status(500).json({ message: 'Internal Server Error', error: err.message || err });
    }
};

module.exports.verifyCodeAndLogin = async (req, res) => {
    try {
        const { email, code } = req.body;

        // Trouver l'utilisateur par e-mail
        const user = await userModel.findOne({ email });

        // Vérifier si l'utilisateur existe
        if (!user) {
            return res.status(404).json({ message: 'User not found' });
        }

        // Vérifier si le code de vérification correspond
        if (verificationCodes[email] !== code) {
            return res.status(400).json({ message: 'Invalid verification code' });
        }

        // Supprimer le code de vérification après vérification
        delete verificationCodes[email];

        // Générer un token JWT pour l'utilisateur
        const token = jwt.sign(
            { userId: user._id, role: user.role },
            process.env.SECRET_KEY,
            { expiresIn: '30d' }
        );

        // Répondre avec le token
        res.status(200).json({ token, role: user.role });
    } catch (err) {
        console.error('Error verifying code:', err);
        res.status(500).json({ message: 'Internal Server Error' });
    }
};
