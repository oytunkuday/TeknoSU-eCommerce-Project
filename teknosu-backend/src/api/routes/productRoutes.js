const express = require('express');
const productController = require('../controllers/productController');
const authController = require('./../controllers/authController');

const router = express.Router();

router
  .route('/')
  .get(productController.getAllProducts)
  .post(
    authController.protect,
    authController.restrictTo('productManager', 'admin'),
    productController.createProduct
  );
router
  .route('/bestsellers')
  .get(productController.getAllProducts);
router
  .route('/search')
  .get(productController.searchProduct);
router
  .route('/:id')
  .get(productController.getProduct)
  .patch(
    authController.protect,
    authController.restrictTo(
      'productManager',
      'admin',
      'salesManager'
    ),
    productController.updateProduct
  )
  .delete(
    authController.protect,
    authController.restrictTo('productManager', 'admin'),
    productController.deleteProduct
  );
router
  .route('/discount/:id')
  .patch(
    authController.protect,
    authController.restrictTo('salesManager', 'admin'),
    productController.discountProduct
  );

  // router
  // .route('/discountProducts')
  // .patch(productController.discountProducts);

module.exports = router;
