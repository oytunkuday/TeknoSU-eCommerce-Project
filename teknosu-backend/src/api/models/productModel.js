const mongoose = require('mongoose');

const productSchema = new mongoose.Schema({
  name: {
    type: String,
    required: [true, 'A product must have a name'],
    unique: true,
  },
  brand: {
    type: String,
    required: [true, 'A product must have a brand'],
  },
  category: {
    type: String,
    required: [true, 'A product must have a category'],
  },
  description: {
    type: String,
    default: 'Good Product',
  },
  distributor: {
    type: String,
    default: 'TeknoSU',
  },
  cost: {
    type: Number,
    required: [true, 'A product must have a cost'],
  },
  price: {
    type: Number,
    required: [true, 'A product must have a price'],
  },
  stocks: {
    type: Number,
    required: [true, 'A product must have a stock'],
    default: 0,
  },
  warranty: {
    type: Boolean,
    required: [true, 'warranty info must be given'],
  },
  recommended: {
    type: Boolean,
    default: false,
  },
  popular: {
    type: Boolean,
    default: false,
  },
  imgs: {
    type: [String],
  },
  ratingsAvg: {
    type: Number,
    default: 0,
  },
  ratingsQuantity: {
    type: Number,
    default: 0,
  },
  sold: {
    type: Number,
    default: 0,
  },
  discount: {
    type: Number,
    default: 0,
  },
  newPrice: {
    type: Number,
    default: 0,
  },
  createdAt: {
    type: Date,
    default: Date.now,
  },
  status: {
    type: String,
    default: 'active',
  }
});

const Product = mongoose.model('Product', productSchema);

module.exports = Product;
