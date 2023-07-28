const Wishlist = require('../models/wishlistModel');
const product = require('../models/productModel');
const APIFeatures = require('../helpers/apiFeatures');
const jwt = require('jsonwebtoken');
const { promisify } = require('util');
const User = require('../models/userModel');
const catchAsync = require('./../utils/catchAsync');
const AppError = require('./../utils/appError');

exports.findWishlistByProductId = async (req, res) => {
  const productIdq = req.params.id;
  console.log(productIdq);
  const wishlists = await Wishlist.find({
    products: { $elemMatch: { productId: productIdq } },
  });
  console.log(wishlists);

  res.status(200).json({
    status: 'success',
    wishlists,
  });
};

exports.addToWishlist = async (req, res) => {
  const { productId } = req.body;

  if (req.headers.authorization) {
    token = req.headers.authorization.split(' ')[1];
    const decoded = await promisify(jwt.verify)(
      token,
      process.env.JWT_SECRET
    );

    const currentUser = await User.findById(decoded.id);
    userId = currentUser._id;
    console.log(currentUser);
  } else {
    return res.status(401).json({
      status: 'fail',
      message: 'not logged in',
    });
  }

  try {
    let wishlist = await Wishlist.findOne({ userId });

    if (wishlist) {
      //wishlist exists for user
      let itemIndex = wishlist.products.findIndex(
        (p) => p.productId == productId
      );

      if (itemIndex > -1) {
        //product exists in the wishlist, update the quantity
      } else {
        //product does not exists in wishlist, add new item
        wishlist.products.push({
          productId,
        });
      }
      wishlist = await wishlist.save();
      return res.status(201).send(wishlist);
    } else {
      //no wishlist for user, create new wishlist
      const newWishlist = await Wishlist.create({
        userId,
        products: [{ productId }],
      });
      // console.log('hata');

      return res.status(201).send(newWishlist);
    }
  } catch (err) {
    console.log(err);
    res.status(500).send('Something went wrong');
  }
};

exports.getWishlist = async (req, res) => {
  token = req.headers.authorization.split(' ')[1];
  const decoded = await promisify(jwt.verify)(
    token,
    process.env.JWT_SECRET
  );
  const currentUser = await User.findById(decoded.id);
  userId = currentUser._id;

  try {
    let wishlist = await Wishlist.findOne({ userId });
    if (wishlist) {
      return res.status(200).send(wishlist);
    } else {
      
        //no wishlist for user, create new wishlist
        const newWishlist = await Wishlist.create({
          userId,
          products: [],
        });
        // console.log('hata');
  
        return res.status(201).send(newWishlist);
      
    }
  } catch (err) {
    console.log(err);
    res.status(500).send('Something went wrong');
  }
};

exports.removeFromWishlist = async (req, res) => {
  const { productId } = req.body;

  token = req.headers.authorization.split(' ')[1];
  const decoded = await promisify(jwt.verify)(
    token,
    process.env.JWT_SECRET
  );

  const currentUser = await User.findById(decoded.id);
  userId = currentUser._id;

  try {
    let wishlist = await Wishlist.findOne({ userId });
    if (wishlist) {
      let itemIndex = wishlist.products.findIndex(
        (p) => p.productId == productId
      );
      if (itemIndex > -1) {
        wishlist.products.splice(itemIndex, 1);
        wishlist = await wishlist.save();
        return res.status(200).send(wishlist);
      } else {
        return res
          .status(404)
          .send('Product not found in wishlist');
      }
    } else {
      return res.status(404).send('Wishlist not found');
    }
  } catch (err) {
    console.log(err);
    res.status(500).send('Something went wrong');
  }
};

exports.emptyWishlist = async (req, res) => {
  token = req.headers.authorization.split(' ')[1];
  const decoded = await promisify(jwt.verify)(
    token,
    process.env.JWT_SECRET
  );
  const currentUser = await User.findById(decoded.id);
  userId = currentUser._id;
  try {
    let wishlist = await Wishlist.findOne({ userId });
    if (wishlist) {
      wishlist.products = [];
      wishlist = await wishlist.save();
      return res.status(200).send(wishlist);
    } else {
      return res.status(404).send('Wishlist not found');
    }
  } catch (err) {
    console.log(err);
    res.status(500).send('Something went wrong');
  }
};
