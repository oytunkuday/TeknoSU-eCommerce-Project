const express = require('express');
const categoryController = require('../controllers/categoryController');
const authController = require('./../controllers/authController');

const router = express.Router();

router.route('/').get(categoryController.getAllCategories);

router
  .route('/activate/:id')
  .patch(
    authController.protect,
    authController.restrictTo('productManager', 'admin'),
    categoryController.activateCategory
  );

router
  .route('/addCategory')
  .post(
    authController.protect,
    authController.restrictTo('productManager', 'admin'),
    categoryController.createCategory
  );

router
  .route('/getActiveCategories')
  .get(
    authController.protect,
    authController.restrictTo('productManager', 'admin'),
    categoryController.getActiveCategories
  );

router
  .route('/:id')
  .get(categoryController.getCategory)
  .patch(
    authController.protect,
    authController.restrictTo('productManager', 'admin'),
    categoryController.updateCategory
  )
  .delete(
    authController.protect,
    authController.restrictTo('productManager', 'admin'),
    categoryController.deleteCategory
  );

module.exports = router;
