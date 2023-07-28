const express = require('express');
const profitController = require('../controllers/profitController');
const authController = require('./../controllers/authController');

const router = express.Router();

router
  .route('/')
  .get(
    authController.protect,
    profitController.getAllProfit
  );
router
  .route('/betweenDates')
  .patch(
    authController.protect,
    authController.restrictTo(
      'productManager',
      'admin',
      'salesManager'
    ),
    profitController.getProfitBetweenDates
  );
router.route('/fixer').get(profitController.fixer);
module.exports = router;

//TODO:
// 1. Add a route to get all the profit for a specific product

// 2. Add a route to get all the profit for a specific category

// 3. Add a route to get all the profit grouped by product

// 4. Add a route to get all the profit grouped by category

// 5. Add a route to get all the profit grouped by date
