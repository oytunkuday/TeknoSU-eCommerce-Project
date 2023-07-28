const express = require('express');
const reviewController = require('../controllers/reviewController');
const authController = require('./../controllers/authController');

const router = express.Router();

router
  .route('/')
  .get(reviewController.getAllReviews)
  .post(
    authController.protect,
    reviewController.createReview
  );

router
  .route('/:id')
  .get(authController.protect, reviewController.getReview)
  .patch(
    authController.protect,
    authController.restrictTo('productManager', 'admin'),
    reviewController.updateReview,
    reviewController.changeAverageRating
  )
  .delete(
    authController.protect,
    authController.restrictTo('productManager', 'admin'),
    reviewController.deleteReview
  );

module.exports = router;
