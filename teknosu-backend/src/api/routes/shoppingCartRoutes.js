const express = require('express');
const router = express.Router();
const jwt = require('jsonwebtoken');
const { promisify } = require('util');
const User = require('../models/userModel');
const catchAsync = require('./../utils/catchAsync');
const AppError = require('./../utils/appError');
const shoppingCartController = require('../controllers/shoppingCartController');

const Cart = require('../models/cartModel');
const product = require('../models/productModel');
const APIFeatures = require('../helpers/apiFeatures');

router
  .route('/addToCart')
  .post(shoppingCartController.addToCart);

router
  .route('/getCart')
  .get(shoppingCartController.getCart);

router
  .route('/removeFromCart')
  .post(shoppingCartController.removeFromCart);

// router.get('/getCart', async (req, res) => {
//   token = req.headers.authorization.split(' ')[1];
//   const decoded = await promisify(jwt.verify)(
//     token,
//     process.env.JWT_SECRET
//   );
//   const currentUser = await User.findById(decoded.id);
//   userId = currentUser._id;

//   try {
//     let cart = await Cart.findOne({ userId });
//     if (cart) {
//       return res.status(200).send(cart);
//     } else {
//       return res.status(404).send('Cart not found');
//     }
//   } catch (err) {
//     console.log(err);
//     res.status(500).send('Something went wrong');
//   }
// });

router
  .route('/emptyCart')
  .post(shoppingCartController.emptyCart);

module.exports = router;
