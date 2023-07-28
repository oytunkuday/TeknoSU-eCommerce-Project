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

exports.addToCart = async (req, res) => {
  const { productId, quantity, name, price } = req.body;

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
    res.cookie(
      'cart',
      [
        {
          productId,
          quantity,
          name,
          price,
        },
      ],
      {
        expires: new Date(Date.now() + 900000000),
        httpOnly: true,
      }
    );

    return res.status(200).json({
      status: 'success',
      message: 'Product added to cart',
    });
  }

  try {
    let cart = await Cart.findOne({ userId });

    if (cart) {
      //cart exists for user
      let itemIndex = cart.products.findIndex(
        (p) => p.productId == productId
      );

      if (itemIndex > -1) {
        //product exists in the cart, update the quantity
        let productItem = cart.products[itemIndex];
        productItem.quantity += quantity;
        if (productItem.quantity < 1) {
          cart.products.splice(itemIndex, 1);
          cart = await cart.save();
          return res.status(201).send(cart);
        }
        cart.products[itemIndex] = productItem;
      } else {
        //product does not exists in cart, add new item
        cart.products.push({
          productId,
          quantity,
          name,
          price,
        });
      }
      cart = await cart.save();
      return res.status(201).send(cart);
    } else {
      //no cart for user, create new cart
      const newCart = await Cart.create({
        userId,
        products: [{ productId, quantity, name, price }],
      });
      // console.log('hata');

      return res.status(201).send(newCart);
    }
  } catch (err) {
    console.log(err);
    res.status(500).send('Something went wrong');
  }
};

const totalPriceCalc = async (cart) => {
  let totalPrice = 0;
  for (let i = 0; i < cart.products.length; i++) {
    const productid = cart.products[i].productId;
    const productx = await product.findById(productid);
    totalPrice +=
      productx.newPrice * cart.products[i].quantity;
  }
  console.log('slm', totalPrice);
  return totalPrice;
};

exports.getCart = async (req, res) => {
  token = req.headers.authorization.split(' ')[1];
  const decoded = await promisify(jwt.verify)(
    token,
    process.env.JWT_SECRET
  );
  const currentUser = await User.findById(decoded.id);
  userId = currentUser._id;

  try {
    let cart = await Cart.findOne({ userId });
    if (cart) {
      cart.products.forEach(async (item) => {});
      let totalprice = await totalPriceCalc(cart);
      return res.status(200).send({ totalprice, cart });
    } else {
      const newCart = await Cart.create({
        userId,
        products: [],
      });
      // console.log('hata');

      return res.status(201).send(newCart);
    }
  } catch (err) {
    console.log(err);
    res.status(500).send('Something went wrong');
  }
};

exports.removeFromCart = async (req, res) => {
  const { productId } = req.body;

  token = req.headers.authorization.split(' ')[1];
  const decoded = await promisify(jwt.verify)(
    token,
    process.env.JWT_SECRET
  );

  const currentUser = await User.findById(decoded.id);
  userId = currentUser._id;

  try {
    let cart = await Cart.findOne({ userId });
    if (cart) {
      let itemIndex = cart.products.findIndex(
        (p) => p.productId == productId
      );
      if (itemIndex > -1) {
        cart.products.splice(itemIndex, 1);
        cart = await cart.save();
        return res.status(200).send(cart);
      } else {
        return res
          .status(404)
          .send('Product not found in cart');
      }
    } else {
      return res.status(404).send('Cart not found');
    }
  } catch (err) {
    console.log(err);
    res.status(500).send('Something went wrong');
  }
};

exports.emptyCart = async (req, res) => {
  token = req.headers.authorization.split(' ')[1];
  const decoded = await promisify(jwt.verify)(
    token,
    process.env.JWT_SECRET
  );
  const currentUser = await User.findById(decoded.id);
  userId = currentUser._id;
  try {
    let cart = await Cart.findOne({ userId });
    if (cart) {
      cart.products = [];
      cart = await cart.save();
      return res.status(200).send(cart);
    } else {
      return res.status(404).send('Cart not found');
    }
  } catch (err) {
    console.log(err);
    res.status(500).send('Something went wrong');
  }
};

// exports.addToCart = async (req, res) => {
//   const productId = req.params.id;
//   const cart = new Cart(
//     req.session.cart ? req.session.cart : {}
//   );

//   Product.findById(productId, function (err, product) {
//     if (err) {
//       return res.redirect('/');
//     }
//     cart.add(product, product.id);
//     req.session.cart = cart;
//     console.log(req.session.cart);
//     res.redirect('/');
//   });
// };

// exports.reduce = async (req, res) => {
//   const productId = req.params.id;
//   const cart = new Cart(
//     req.session.cart ? req.session.cart : {}
//   );
//   cart.reduceByOne(productId);
//   req.session.cart = cart;
//   res.redirect('/cart');
// };

// exports.emptyCart = async (req, res) => {
//   const cart = new Cart(
//     req.session.cart ? req.session.cart :  {}
//   );
//   cart.products =[];
//   req.session.cart = cart;
//   res.redirect('/cart');
// };
