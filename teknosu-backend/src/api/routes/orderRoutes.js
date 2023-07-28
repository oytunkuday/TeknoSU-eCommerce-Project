const express = require('express');

const orderController = require('../controllers/orderController');
const authController = require('./../controllers/authController');

const router = express.Router();

router.route('/complete').post(orderController.createOrder);
router
  .route('/getOrderByUser')
  .get(orderController.getOrderByUser);
router
  .route('/')
  .get(authController.protect, orderController.getAllOrders)
  .post(
    authController.protect,
    orderController.createOrder
  );

router
  .route('/pm/getActiveOrders')
  .get(
    authController.protect,
    authController.restrictTo(
      'admin',
      'productManager',
      'salesManager'
    ),
    orderController.getActiveOrders
  );
router
  .route('/getFiles')
  .patch(orderController.getFileNames);

router
  .route('/:id')
  .get(authController.protect, orderController.getOrder)
  .patch(
    authController.protect,
    orderController.updateOrder
  )
  .delete(
    authController.protect,
    authController.restrictTo('admin'),
    orderController.deleteOrder
  );

router
  .route('/refunds/getAllRefundRequests')
  .get(
    authController.protect,
    authController.restrictTo('admin', 'salesManager'),
    orderController.getRefundRequests
  );

router
  .route('/refund/:id')
  .patch(
    authController.protect,
    orderController.refundAProduct
  );

router
  .route('/approveRefund/:id')
  .patch(
    authController.protect,
    authController.restrictTo('admin', 'salesManager'),
    orderController.approveRefund
  );
router
  .route('/rejectRefund/:id')
  .patch(
    authController.protect,
    authController.restrictTo('admin', 'salesManager'),
    orderController.rejectRefund
  );

router
  .route('/fix/fixOrders')
  .get(orderController.OrderFixer);

module.exports = router;
