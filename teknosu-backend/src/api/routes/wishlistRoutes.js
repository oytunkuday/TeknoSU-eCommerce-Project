const express = require('express');
const router = express.Router();
const jwt = require('jsonwebtoken');
const { promisify } = require('util');
const User = require('../models/userModel');
const catchAsync = require('./../utils/catchAsync');
const AppError = require('./../utils/appError');

const Wishlist = require('../models/wishlistModel');
const wishlistController = require('../controllers/wishlistController');
const product = require('../models/productModel');
const APIFeatures = require('../helpers/apiFeatures');

router
  .route('/addToWishlist')
  .post(wishlistController.addToWishlist);

router
  .route('/getWishlist')
  .get(wishlistController.getWishlist);

router
  .route('/removeFromWishlist')
  .post(wishlistController.removeFromWishlist);

// router.get('/getWishlist', async (req, res) => {
//   token = req.headers.authorization.split(' ')[1];
//   const decoded = await promisify(jwt.verify)(
//     token,
//     process.env.JWT_SECRET
//   );
//   const currentUser = await User.findById(decoded.id);
//   userId = currentUser._id;

//   try {
//     let wishlist = await Wishlist.findOne({ userId });
//     if (wishlist) {
//       return res.status(200).send(wishlist);
//     } else {
//       return res.status(404).send('Wishlist not found');
//     }
//   } catch (err) {
//     console.log(err);
//     res.status(500).send('Something went wrong');
//   }
// });

router
  .route('/emptyWishlist')
  .post(wishlistController.emptyWishlist);

router
  .route('/:id')
  .get(wishlistController.findWishlistByProductId);

module.exports = router;
