// backend/models/favorite_model.js

const mongoose = require('mongoose');
const Schema = mongoose.Schema;

const favoriteSchema = new Schema(
  {
    userId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'AUTH',
      required: true
    },
    placeId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'Place',
      required: true
    },
  },
  {
    timestamps: true
  }
);

const Favorite = mongoose.model('Favorite', favoriteSchema);
module.exports = Favorite;
