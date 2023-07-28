const Order = require('../models/orderModel');
const Profit = require('../models/profitModel');
const Cart = require('../models/cartModel');
const Product = require('../models/productModel');
const User = require('../models/userModel')
const APIFeatures = require('../helpers/apiFeatures');
const createReceipt = require('../utils/createReceipt');
const userController = require('./userController');
const emailer = require('../utils/email');
const fs = require('fs');

exports.getAllOrders = async (req, res) => {
  try {
    const features = new APIFeatures(
      Order.find(),
      req.query
    )
      .filter()
      .sort()
      .limitFields();
    const orders = await features.query;

    //SEND RESPONSE
    res.status(200).json({
      status: 'success',
      results: orders.length,
      data: {
        orders,
      },
    });
  } catch (err) {
    res.status(404).json({
      status: 'Fail',
      message: err,
    });
  }
};

exports.getOrderByUser = async (req, res) => {
  try {
    const orders = await Order.find({
      user: req.query.userid,
    }).sort({ createdAt: -1 });
    console.log(orders);
    res.status(200).json({
      status: 'success',
      data: {
        orders,
      },
    });
  } catch (err) {
    res.status(404).json({
      status: 'Fail',
      message: err,
    });
  }
};

exports.getOrder = async (req, res) => {
  try {
    let totalprice = 0;
    const order = await Order.findById(req.params.id);
    order.products.forEach((p) => {
      totalprice += p.price * p.quantity;
    });
    res.status(200).json({
      status: 'success',
      totalprice,
      data: {
        orders: order,
      },
    });
  } catch (err) {
    res.status(404).json({
      status: 'Fail',
      message: err,
    });
  }
};

exports.getFileNames = async (req, res) => {
  let startDate = req.body.startDate;
  let endDate = req.body.endDate;
  try {
    const path = './receipts/';
    const pdfs = await fs.readdirSync(path);
    console.log('zort');
    var arr = [];
    for (let i = 0; i < pdfs.length; i++) {
      var pdfss = pdfs[i].replace('.pdf', '');
      let onlyDate = pdfss.substring(
        pdfss.indexOf('-') + 1,
        pdfs[i].length
      );
      let newDate = onlyDate.split('-')[2];
      newDate += '-' + onlyDate.split('-')[1];
      newDate += '-' + onlyDate.split('-')[0];
      console.log(newDate);
      console.log(startDate);
      console.log(endDate);
      if (newDate >= startDate && newDate <= endDate) {
        arr.push(pdfs[i]);
      }
      // arr.push(newDate);
    }
    arr.sort();
    console.log(arr);

    res.status(200).json({
      status: 'success',
      data: {
        pdfs,
      },
    });
  } catch (err) {
    res.status(404).json({
      status: 'Fail',
      message: err,
    });
  }
};

exports.createOrder = async (req, res) => {
  // console.log(req.body);
  try {
    const newOrder = await Order.create(req.body);
    newOrder.populate('user');
    const user = newOrder.user;
    console.log('start');
    const curruser = await User.findById(req.body.user);
    console.log(curruser)

    const newProfit = await Profit.create(req.body);
    console.log(newProfit)

    let products = newOrder.products;
    products = products.map((product) => ({
      quantity: product.quantity,
      description: product.description,
      price: product.price,
      'tax-rate': product['tax-rate'],
    }));


    createReceipt
      .createReceipt(newOrder, products, curruser)
      .then((x) => emailer.sendEmail(x, curruser));

    let products2 = newProfit.products;
    products2 = products2.map((product) => ({
      quantity: product.quantity,
      productId: product.productId,
      cost: product.cost,
      price: product.price,
      refunded: product.refunded,
    }));


    newProfit.products = products2;
    newProfit.orderid = newOrder._id;
    for (let i = 0; i < newProfit.products.length; i++) {
      const realProduct = await Product.findById(
        newProfit.products[i].productId
      );
      newProfit.products[i].cost = realProduct.cost;
    }
    await newProfit.save();

    await Cart.findOneAndUpdate(
      { userId: req.body.user },
      { products: [] },
      {
        upsert: true,
        new: true,
      }
    );
    const productarray = req.body.products;
    for (let i = 0; i < productarray.length; i++) {
      const product = await Product.findOneAndUpdate(
        { _id: req.body.products[i].productId },
        {
          $inc: {
            stocks: req.body.products[i].quantity * -1,
            sold: req.body.products[i].quantity,
          },
        },
        {
          upsert: true,
          new: true,
        }
      );
      // console.log(productarray);
    }
    res.status(201).json({
      status: 'success',
      data: {
        order: newOrder,
      },
    });
  } catch (err) {
    res.status(400).json({
      status: 'Fail',
      message: JSON.stringify(err),
    });
  }
};
//
exports.updateOrder = async (req, res, next) => {
  try {
    await Order.findByIdAndUpdate(req.params.id, req.body, {
      new: true,
      runValidators: true,
    });
    let order = await Order.findById(req.params.id);
    if (req.body.status === 'Cancelled') {
      for (let i = 0; i < order.products.length; i++) {
        var product = await Product.findById(
          order.products[i].productId
        );
        if (product === null) {
          return res.status(404).json({
            status: 'Fail',
            message: 'Product not found',
          });
        }
        product.stocks =
          product.stocks + order.products[i].quantity;
        product.sold =
          product.sold - order.products[i].quantity;
        await product.save();
      }
    }
    if (req.body.status === 'In-Transit') {
      order.deliveryId = Math.floor(
        Math.random() * 1000000000
      );
      await order.save();
    }
    return res.status(200).json({
      status: 'Success',
      data: {
        order,
      },
    });
    next();
  } catch (err) {
    res.status(404).json({
      status: 'Fail',
      message: err,
    });
  }
};

exports.deleteOrder = async (req, res) => {
  try {
    await Order.findByIdAndDelete(req.params.id);
    res.status(204).json({
      status: 'Success',
      data: null,
    });
  } catch (err) {
    res.status(400).json({
      status: 'Fail',
      message: err,
    });
  }
};

exports.getOrdersByDate = async (req, res) => {
  try {
    const orders = await Order.find({
      createdAt: {
        $gte: req.query.startDate,
        $lte: req.query.endDate,
      },
    });
    res.status(200).json({
      status: 'success',
      data: {
        orders,
      },
    });
  } catch (err) {
    res.status(404).json({
      status: 'Fail',
      message: err,
    });
  }
};

// exports.cancelOrder = async (req, res) => {
//   try {
//     const order = await Order.findById(req.params.id);
//     order.status = 'cancelled';
//     await order.save();
//     res.status(200).json({
//       status: 'success',
//       data: {
//         order,
//       },
//     });
//   } catch (err) {
//     res.status(404).json({
//       status: 'Fail',
//       message: err,
//     });
//   }
// };

exports.refundAProduct = async (req, res) => {
  try {
    console.log(req.body.productId);
    console.log(req.params.id);
    const order = await Order.findById(req.params.id);
    console.log('order : ', order);
    console.log(order.products[0]);
    const product = order.products.find(
      (product) => product.productId === req.body.productId
    );
    console.log(product);
    const orderDate = order.createdAt;
    const refundDate = new Date();
    const diff = refundDate.getTime() - orderDate.getTime();
    const days = Math.floor(diff / (1000 * 60 * 60 * 24));
    console.log('ORDER EDELI GECEN GUN: ', days);
    if (days > 30) {
      res.status(400).json({
        status: 'Fail',
        message: 'Cannot refund after 30 days',
      });
    }
    product.refunded = 'In Progress';
    await order.save();
    const refundedQuantity = product.quantity;
    // var product2 = await Product.findById(
    //   req.body.productId
    // );
    // console.log(
    //   'refunded products quantity before refund: ',
    //   product2.stocks
    // );
    // console.log(
    //   'refunded products sold before refund: ',
    //   product2.sold
    // );
    // product2.stocks = product2.stocks + refundedQuantity;
    // product2.sold = product2.sold - refundedQuantity;
    // console.log(
    //   'refunded products quantity after refund: ',
    //   product2.stocks
    // );
    // console.log(
    //   'refunded products sold aftter refund: ',
    //   product2.sold
    // );
    // await product2.save();
    res.status(200).json({
      status: 'success',
      data: {
        order,
      },
    });
  } catch (err) {
    res.status(404).json({
      status: 'Fail',
      message: err,
    });
  }
};

exports.getRefundRequests = async (req, res) => {
  try {
    console.log('slm');
    const features = new APIFeatures(
      Order.find(),
      req.query
    )
      .filter()
      .sort();
    const orders = await features.query;
    console.log(orders.length);
    let refundRequests = [];
    for (let i = 0; i < orders.length; i++) {
      const products = orders[i].products;
      for (let j = 0; j < products.length; j++) {
        console.log(products[j].refunded);
        if (products[j].refunded === 'In Progress') {
          var refund = {
            orderId: orders[i]._id,
            productId: products[j].productId,
          };
          refundRequests.push(refund);
        }
      }
      orders[i].products = products;
    }
    res.status(200).json({
      status: 'success',
      results: refundRequests.length,
      data: {
        refundRequests,
      },
    });
  } catch (err) {
    res.status(404).json({
      status: 'Fail',
      message: err,
    });
  }
};

exports.approveRefund = async (req, res) => {
  try {
    const order = await Order.findById(req.params.id);
    console.log(order)
    const product = order.products.find(
      (product) => product.productId === req.body.productId
    );

    const profit = await Profit.findOne({
      orderid: req.params.id,
    });
    console.log(profit);
    const profitProduct = profit.products.find(
      (product) => product.productId === req.body.productId
    );
    console.log('Before', profitProduct.refunded);
    profitProduct.refunded = 'true';
    console.log('After', profitProduct.refunded);
    await profit.save();
    product.refunded = 'True';
    await order.save();
    const refundedQuantity = product.quantity;
    var product2 = await Product.findById(
      req.body.productId
    );
    console.log(
      'refunded products quantity before refund: ',
      product2.stocks
    );
    console.log(
      'refunded products sold before refund: ',
      product2.sold
    );
    product2.stocks = product2.stocks + refundedQuantity;
    product2.sold = product2.sold - refundedQuantity;
    console.log(
      'refunded products quantity after refund: ',
      product2.stocks
    );
    console.log(
      'refunded products sold aftter refund: ',
      product2.sold
    );
    await product2.save();
    res.status(200).json({
      status: 'success',
      refundedAmount: product.price * refundedQuantity,
      data: {
        order,
      },
    });
  } catch (err) {
    res.status(404).json({
      status: 'Fail',
      message: err,
    });
  }
};

exports.rejectRefund = async (req, res) => {
  try {
    const order = await Order.findById(req.params.id);
    const product = order.products.find(
      (product) => product.productId === req.body.productId
    );
    product.refunded = 'Rejected';
    await order.save();
    res.status(200).json({
      status: 'success',
      data: {
        order,
      },
    });
  } catch (err) {
    res.status(404).json({
      status: 'Fail',
      message: err,
    });
  }
};

exports.getActiveOrders = async (req, res) => {
  try {
    const orders = await Order.find({
      status: { $in: ['In-Transit', 'Processing'] },
    });
    res.status(200).json({
      status: 'success',
      results: orders.length,
      data: {
        orders,
      },
    });
  } catch (err) {
    res.status(404).json({
      status: 'Fail',
      message: err,
    });
  }
};

exports.OrderFixer = async (req, res) => {
  try {
    const orders = await Order.find();
    for (let i = 0; i < orders.length; i++) {
      let total = 0;
      const order = orders[i];
      const products = order.products;
      for (let j = 0; j < products.length; j++) {
        const product = products[j];
        total = total + product.price * product.quantity;
      }
      order.orderTotal = total;
      await order.save();
    }
    res.status(200).json({
      status: 'success',
      results: orders.length,
      data: {
        orders,
      },
    });
  } catch (err) {
    res.status(404).json({
      status: 'Fail',
      message: err,
    });
  }
};

// exports.getwithoutproductid = async (req, res) => {
//   try {
//     const orders = await Order.find();
//     order.forEach(async (order) => {
//       order.products.forEach(async (product) => {
//         if (!product.productId) {
//           console.log(order._id);
//         }
//         res.status(200).json({
//           status: 'success',
//           results: orders.length,
//           data: {
//             orders,
//           },
//         });
//       });
//     });
//   } catch (err) {
//     res.status(404).json({
//       status: 'Fail',
//       message: err,
//     });
//   }
// };

// exports.refundOrder = async (req, res) => {
//   try {
//     const order = await Order.findById(req.params.id);
//     const orderDate = order.createdAt;
//     const today = new Date();
//     const diff = today.getTime() - orderDate.getTime();
//     if (diff > 2592000000) {
//       res.status(400).json({
//         status: 'Fail',
//         message: 'Order is older than 30 days',
//       });
//     }
//     order.status = 'refunded';
//     await order.save();
//     res.status(200).json({
//       status: 'success',
//       data: {
//         order,
//       },
//     });
//   } catch (err) {
//     res.status(404).json({
//       status: 'Fail',
//       message: err,
//     });
//   }
// }
