// review / rating / createdAt / ref to tour / ref to user
const mongoose = require('mongoose');
// const Tour = require('./tourModel');

const reviewSchema = new mongoose.Schema({
  review: {
    type: String,
  },
  rating: {
    type: Number,
    min: 1,
    max: 5,
    required: [true, 'Please provide a rating'],
  },
  createdAt: {
    type: Date,
    default: Date.now,
  },
  product: {
    type: String,
    required: [true, 'Review must belong to a product.'],
  },
  user: {
    type: String,
    required: [true, 'Review must belong to a user'],
  },
  approved: {
    type: String,
    default: 'not reviewed',
  },
});

const Review = mongoose.model('Review', reviewSchema);

module.exports = Review;
