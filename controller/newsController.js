const newsModel = require('../models/newsSchema');


//read
module.exports.getNews = async (req,res) => { 

    try{
        const newsList = await newsModel.find()
        res.status(200).json({newsList})
    }catch(err){
        res.status(500).json({message: err.message})
    }
}

//create
module.exports.addNews = async (req,res) => { 

    try{
        console.log(req.body);
        const{ category , description }=req.body;
        const {filename} =req.file
        const news = new newsModel({
            category ,
             description , 
             news_photo:filename
            });
        const newsAdded = await news.save()
        res.status(201).json(newsAdded);
    }catch(err){
        res.status(500).json({message: err.message})
    }
}
module.exports.deleteNews = async (req,res)=>{
    try{
        console.log(req.params);
        const {id} = req.params

        const check = await newsModel.findById(id);
        if(!check)
        {
            throw new Error("news not found here!");
        }
        const news = await newsModel.findByIdAndDelete(id);
        res.status(200).json({news});
    }catch(err){
        res.status(500).json({message: err.message})
    }
}

module.exports.updateNews = async (req, res) => {
    try {
      const { id } = req.params; // Récupération de l'ID depuis les paramètres
      const { category, description } = req.body;
      const newsPhoto = req.file ? req.file.filename : null; // Handle the new file
  
      // Vérification si le news avec l'ID donné existe
      const check = await newsModel.findById(id);
      if (!check) {
        return res.status(404).json({ message: "News not found!" });
      }
  
      
      // Mise à jour des informations
      const updateFields = {
        category,
        description,
        ...(newsPhoto && { news_photo: newsPhoto }) // Update photo only if a new one is provided
    };
  
      const updatedNews = await newsModel.findByIdAndUpdate(id, {
        $set: updateFields
      }, { new: true });
  
      res.status(200).json(updatedNews); // Correction du code de statut HTTP pour une mise à jour réussie
    } catch (err) {
      res.status(500).json({ message: err.message });
    }
  };
  
// newsController.js
module.exports.getNewsById = async (req, res) => {
    try {
      const { id } = req.params;
      const news = await newsModel.findById(id);
  
      if (!news) {
        return res.status(404).json({ message: 'News not found' });
      }
  
      res.status(200).json({ news });
    } catch (err) {
      res.status(500).json({ message: err.message });
    }
  };
  // Afficher les news selon la catégorie sélectionnée
module.exports.getNewsByCategory = async (req, res) => {
  try {
    const { category } = req.params;
    console.log(`Fetching news for category: ${category}`); // Debugging line

    // Rechercher les actualités par catégorie
    const newsList = await newsModel.find({ category });

    if (newsList.length === 0) {
      console.log('No news found for this category'); // Debugging line
      return res.status(404).json({ message: 'No news found for this category' });
    }

    res.status(200).json({ newsList });
  } catch (err) {
    console.error('Error fetching news by category:', err); // Debugging line
    res.status(500).json({ message: err.message });
  }
};
