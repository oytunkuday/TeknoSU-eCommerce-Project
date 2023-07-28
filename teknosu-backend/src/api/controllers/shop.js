/*
const ShoppingCart = require('../models/cart');
const Product = require('../models/product');

exports.addToCart = (req, res, next) => {
  const ProductToAdd = Product.findById(req.body.id)[0];
  ShoppingCart.save(ProductToAdd);
  res.redirect('/cart');
};

exports.getCart = (req, res, next) => {
  res.render('cart', {
    cart: ShoppingCart.getCart(),
    pageTitle: 'Shopping Cart Detail',
    path: '/cart',
    name: 'User name should be added',
  });
};

exports.deleteInCart = (req, res, next) => {
  ShoppingCart.delete(req.body.id);
  res.redirect('/cart');
};
*/