// backend/routes/favorite_Routes.js

const express = require('express');
const router = express.Router();
const favoriteController = require('../logic/favorite_Controller');

// Add a place to favorites
router.post('/favorites', favoriteController.addFavorite);

// Get all favorite places for a user
router.get('/favorites/:userId', favoriteController.getFavorites);

module.exports = router;
