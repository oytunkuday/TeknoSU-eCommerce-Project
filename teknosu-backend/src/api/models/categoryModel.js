const mongoose = require('mongoose');

const categorySchema = new mongoose.Schema({
  name: {
    type: String,
    required: [true, 'A category must have a name'],
    unique: true,
  },
  photo: {
    type: String,
    required: [true, 'A category must have a photo url'],
  },
  status: {
    type: String,
    default: 'active',
  }
});

const Category = mongoose.model('Category', categorySchema);

module.exports = Category;
