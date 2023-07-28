const Profit = require('../models/profitModel');
const Order = require('../models/orderModel');
const Product = require('../models/productModel');

exports.getAllProfit = async (req, res) => {
  try {
    const profit = await Profit.find();
    console.log(profit);
    let totalRevenue = 0;
    let totalprofit = 0;
    for (let i = 0; i < profit.length; i++) {
      console.log('-----------------');
      console.log('orderid:', profit[i].orderid);
      for (let j = 0; j < profit[i].products.length; j++) {
        if (profit[i].products[j].refunded == 'false') {
          totalRevenue +=
            profit[i].products[j].price *
            profit[i].products[j].quantity;
          console.log(
            'price:',
            profit[i].products[j].price
          );
          console.log('cost:', profit[i].products[j].cost);
          totalprofit +=
            (profit[i].products[j].price -
              profit[i].products[j].cost) *
            profit[i].products[j].quantity;
          console.log('slm', totalprofit);
        }
      }
    }
    res.status(200).json({
      status: 'success',
      data: {
        totalRevenue,
        totalprofit,
      },
    });
  } catch (err) {
    res.status(404).json({
      status: 'Fail',
      message: err,
    });
  }
};

//FIXME:

const totalProfitCalc = async (profit) => {
  let totalprofit = 0;
  for (let i = 0; i < profit.length; i++) {
    for (let j = 0; j < profit[i].products.length; j++) {
      if (profit[i].products[j].refunded == 'false') {
        totalprofit +=
          (profit[i].products[j].price -
            profit[i].products[j].cost) *
          profit[i].products[j].quantity;
        // console.log('slm', totalprofit);
      }
    }
  }
  return totalprofit;
};

// not finished yet
// date may need formatting

exports.getProfitBetweenDates = async (req, res) => {
  try {
    let totalRevenue = 0;
    var dict = {};
    const startDate = req.body.startDate + 'T00:00:00.000Z';
    const endDate = req.body.endDate + 'T23:59:59.000Z';
    const profit = await Profit.find({
      createdAt: {
        $gte: startDate,
        $lte: endDate,
      },
    });
    // console.log(profit);
    for (let i = 0; i < profit.length; i++) {
      let date = profit[i].createdAt
        .toString()
        .substring(0, 15);
      console.log('profit[i].date:', date);
      for (let j = 0; j < profit[i].products.length; j++) {
        if (profit[i].products[j].refunded == 'false') {
          console.log('burdayim');
          totalRevenue +=
            profit[i].products[j].price *
            profit[i].products[j].quantity;
          if (dict[date] == undefined) {
            dict[date] =
              (profit[i].products[j].price -
                profit[i].products[j].cost) *
              profit[i].products[j].quantity;
          } else {
            dict[date] +=
              (profit[i].products[j].price -
                profit[i].products[j].cost) *
              profit[i].products[j].quantity;
          }
        }
      }
    }
    console.log('dict:', dict); //
    let totalprofit = await totalProfitCalc(profit);
    console.log(totalprofit);
    res.status(200).json({
      status: 'success',
      data: {
        totalRevenue,
        totalprofit,
        dict,
      },
    });
  } catch (err) {
    res.status(404).json({
      status: 'Fail',
      message: err,
    });
  }
};

//pid cost quantity price
exports.fixer = async (req, res) => {
  try {
    const order = await Order.find();
    for (let i = 0; i < order.length; i++) {
      const profit = await Profit.findOne({
        orderid: order[i]._id,
      });
      if (profit) {
        console.log('order id  : ', order[i]._id);
        const products = order[i].products;
        console.log(products);
        for (let j = 0; j < profit.products.length; j++) {
          console.log(
            'producttid  : ',
            products[j].productId
          );
          const productTemp = await Product.findById(
            products[j].productId
          );
          console.log('productTempid:', productTemp._id);
          profit.products[j].cost = productTemp.cost;
          profit.products[j].price = productTemp.price;
          profit.products[j].quantity =
            order[i].products[j].quantity;
          // profit.products[j].refunded = bool(
          //   order[i].products[j].refunded
          // );
          profit.products[j].productId = productTemp._id;
          console.log(profit.products[j]);
          profit.save();
        }
      }
      console.log('----------------------');
    }

    let counter = 0;
    const profit = await Profit.find();
    for (let x = 0; x < profit.length; x++) {
      const order = await Order.findById(profit[x].orderid);

      console.log('**********************');
      console.log(order);

      if (order != null) {
        console.log('order id: ', order._id, 'exists');
      } else {
        counter++;
        console.log("order doesn't exist");
        console.log(profit[x]._id);
        await Profit.findByIdAndDelete(profit[x]._id);
      }
    }
    console.log(counter);
    res.status(200).json({
      status: 'success',
      message: 'hll',
    });
  } catch (err) {
    res.status(404).json({
      status: 'Fail',
      message: err,
    });
  }
};

//TODO:

//we need to group profit by date for example get profits monthly or yearly so that we can plot it

//we also need to group profit by product so that we can plot it
