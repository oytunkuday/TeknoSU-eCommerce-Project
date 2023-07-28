const mongoose = require('mongoose');

const profitSchema = new mongoose.Schema({
  orderid: {
    type: String,
  },

  createdAt: {
    type: Date,
    default: Date.now,
  },

  products: [
    {
      productId: { type: String, required: true },
      quantity: Number,
      cost: Number,
      price: Number,

      refunded: {
        type: String,
        default: 'false',
      },
    },
  ],
});

const Profit = mongoose.model('Profit', profitSchema);

module.exports = Profit;
