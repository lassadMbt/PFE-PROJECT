// backend/controllers/favorite_Controller.js

const Favorite = require('../models/favorite_model');
const Place = require('../models/upload-model');

// Add a place to favorites
exports.addFavorite = async (req, res) => {
  try {
    const { userId, placeId } = req.body;

    // Check if the favorite already exists
    const existingFavorite = await Favorite.findOne({ userId, placeId });
    if (existingFavorite) {
      return res.status(400).json({ message: 'This place is already in your favorites' });
    }

    const favorite = new Favorite({ userId, placeId });
    await favorite.save();
    res.status(201).json(favorite);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// Get all favorite places for a user
exports.getFavorites = async (req, res) => {
  try {
    const { userId } = req.params;

    const favorites = await Favorite.find({ userId }).populate('placeId');
    res.status(200).json(favorites);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};
