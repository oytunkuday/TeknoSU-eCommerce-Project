const mongoose = require('mongoose');

const WishlistSchema = new mongoose.Schema({
  userId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
  },
  products: [
    {
      productId: {type: String, required: true},
    },
  ],
});

module.exports = mongoose.model('Wishlist', WishlistSchema);
