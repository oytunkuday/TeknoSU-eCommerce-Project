const mongoose = require('mongoose');
const userModel = require('./userModel');

const orderSchema = new mongoose.Schema({
  user: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
  },
  products: [
    {
      productId: {
        type: String,
        required: true,
      },
      quantity: Number,
      description: String,
      price: Number,
      'tax-rate': {
        type: Number,
        default: 0,
      },
      refunded: {
        type: String,
        default: 'false',
      },
    },
  ],
  orderTotal: {
    type: Number,
    required: true,
  },
  address: {
    type: String,
    required: [true, 'address info must be given'],
  },
  zipCode: {
    type: Number,
    required: [true, 'zipCode info must be given'],
  },
  city: {
    type: String,
    required: [true, 'city info must be given'],
  },
  name: {
    type: String,
    required: [true, 'name info must be given'],
  },
  country: {
    type: String,
    required: [true, 'Country info must be given'],
  },
  paymentId: {
    type: String,
    required: [true, 'paymentId info must be given'],
  },
  deliveryId: {
    type: String,
    default: '',
  },
  status: {
    // "In-Transit", "Delivered", "Cancelled", "Processing"
    type: String,
    required: [true, 'Status info must be given'],
    enum: [
      'In-Transit',
      'Delivered',
      'Cancelled',
      'Processing',
    ],
    default: 'Processing',
  },
  createdAt: {
    type: Date,
    default: Date.now,
  },
});

const Order = mongoose.model('Order', orderSchema);

module.exports = Order;
