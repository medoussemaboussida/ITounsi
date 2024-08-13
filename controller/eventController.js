const eventModel = require('../models/eventSchema');


//read
module.exports.getEvent = async (req,res) => { 

    try{
        const eventList = await eventModel.find()
        res.status(200).json({eventList})
    }catch(err){
        res.status(500).json({message: err.message})
    }
}

//create
module.exports.addEvent = async (req,res) => { 

    try{
        console.log(req.body);
        const{ title , event_description , event_date , place }=req.body;
        const {filename} =req.file
        const events = new eventModel({
             title ,
             event_description ,
             event_date ,
             place ,
             event_photo:filename
            });
        const eventAdded = await events.save()
        res.status(201).json(eventAdded);
    }catch(err){
        res.status(500).json({message: err.message})
    }
}

module.exports.deleteEvent = async (req,res)=>{
    try{
        console.log(req.params);
        const {id} = req.params

        const check = await eventModel.findById(id);
        if(!check)
        {
            throw new Error("event not found here!");
        }
        const event = await eventModel.findByIdAndDelete(id);
        res.status(200).json({event});
    }catch(err){
        res.status(500).json({message: err.message})
    }
}


module.exports.updateEvent = async (req, res) => {
    try {
      const { id } = req.params; // Récupération de l'ID depuis les paramètres
      const { title, event_description , event_date , place } = req.body;
      const eventPhoto = req.file ? req.file.filename : null; // Handle the new file
  
      // Vérification si le news avec l'ID donné existe
      const check = await eventModel.findById(id);
      if (!check) {
        return res.status(404).json({ message: "News not found!" });
      }
  
      
      // Mise à jour des informations
      const updateFields = {
        title, event_description , event_date , place ,
        ...(eventPhoto && { event_photo: eventPhoto }) // Update photo only if a new one is provided
    };
  
      const updatedEvent = await eventModel.findByIdAndUpdate(id, {
        $set: updateFields
      }, { new: true });
  
      res.status(200).json(updatedEvent); // Correction du code de statut HTTP pour une mise à jour réussie
    } catch (err) {
      res.status(500).json({ message: err.message });
    }
  };
  
// newsController.js
module.exports.getEventById = async (req, res) => {
    try {
      const { id } = req.params;
      const event = await eventModel.findById(id);
  
      if (!event) {
        return res.status(404).json({ message: 'event not found' });
      }
  
      res.status(200).json({ event });
    } catch (err) {
      res.status(500).json({ message: err.message });
    }
  };