const Product = require('../models/productModel');
const wishlistController = require('../controllers/wishlistController');
const wishlist = require('../models/wishlistModel');
const APIFeatures = require('../helpers/apiFeatures');
const Cart = require('../models/cartModel');
const emailer = require('../utils/email');

exports.getAllProducts = async (req, res) => {
  try {
    const features = new APIFeatures(
      Product.find(),
      req.query
    )
      .filter()
      .sort()
      .limitFields()
      .paginate();
    const products = await features.query;

    //SEND RESPONSE
    res.status(200).json({
      status: 'success',
      results: products.length,
      data: {
        products,
      },
    });
  } catch (err) {
    res.status(404).json({
      status: 'Fail',
      message: err,
    });
  }
};

exports.searchProductNew = async (name) => {
  const product = await Product.find({
    $text: { $search: name },
  });
  return product;
};

exports.searchProduct = async (req, res) => {
  console.log(req.query.name);
  try {
    const features = new APIFeatures(
      Product.find({
        name: {
          $regex: req.query.name,
          $options: 'i',
        },
      }),
      req.query
    )
      .filter()
      .sort()
      .limitFields()
      .paginate();
    let products = await features.query;
    if (products.length === 0) {
      products = this.searchProductNew(req.query.name);
    }

    res.status(200).json({
      status: 'Success',
      data: {
        products,
      },
    });
  } catch (err) {
    res.status(404).json({
      status: 'Fail',
      message: err,
    });
  }
};

exports.getProduct = async (req, res) => {
  try {
    const product = await Product.findById(req.params.id);

    res.status(200).json({
      status: 'success',
      data: {
        products: product,
      },
    });
  } catch (err) {
    res.status(404).json({
      status: 'Fail',
      message: err,
    });
  }
};

exports.createProduct = async (req, res) => {
  try {
    const newProduct = await Product.create(req.body);
    newProduct.newPrice =
      newProduct.price -
      (newProduct.price * newProduct.discount) / 100;
    newProduct.save();
    res.status(201).json({
      status: 'success',
      data: {
        product: newProduct,
      },
    });
  } catch (err) {
    res.status(404).json({
      status: 'Fail',
      message: err,
    });
  }
};

exports.updateProduct = async (req, res) => {
  try {

    console.log(req.body.price);
    const product = await Product.findByIdAndUpdate(
      req.params.id,
      req.body,
      { new: true, runValidators: true }
    );
    
    if (req.body.price) {
      const product = await Product.findById(req.params.id);
      product.price = req.body.price;
      product.newPrice = req.body.price;
      product.discount = 0;
      product.save();
    } 
    
      
    
    

    res.status(200).json({
      status: 'Success',
      data: {
        product,
      },
    });
  } catch (err) {
    res.status(404).json({
      status: 'Fail',
      message: err,
    });
  }
};

exports.deleteProduct = async (req, res) => {
  try {


    //FIXER
    // const products = await Product.find();
    // console.log(products[1]);
    // for(let i = 0; i < products.length; i++){
    //   console.log(products[i]);
    //   products[i].status = 'active';
    //   products[i].save();
    // }



    const carts = await Cart.find({
      products: {
        $elemMatch: { productId: req.params.id },
      },
    });
    console.log(carts);
    carts.forEach(async (cart) => {
      cart.products.forEach(async (product) => {
        if (product.productId === req.params.id) {
          console.log(cart.id);
          await Cart.findByIdAndUpdate(
            cart._id,
            {
              $pull: {
                products: { productId: req.params.id },
              },
            },
            { new: true }
          );
        }
      });
    });
    const wishlists = await wishlist.find({
      products: {
        $elemMatch: { productId: req.params.id },
      },
    });
    wishlists.forEach(async (wl) => {
      wl.products.forEach(async (product) => {
        if (product.productId === req.params.id) {
          console.log(wl.id);
          await wishlist.findByIdAndUpdate(
            wl._id,
            {
              $pull: {
                products: { productId: req.params.id },
              },
            },
            { new: true }
          );
        }
      });
    });
    toDelete = await Product.findById(req.params.id);
    toDelete.status = 'passive'
    toDelete.save();
    return res.status(204).json({
      status: 'Success',
      data: toDelete,
    });
    
  } catch (err) {
    res.status(400).json({
      status: 'Fail',
      message: err,
    });
  }
};

exports.discountProduct = async (req, res) => {
  
  try {
    const product = await Product.findById(req.params.id);
    let oldDiscount = product.discount;
    product.discount = req.body.discount;
    let newPrice =
      product.price -
      (product.price * product.discount) / 100;
    product.newPrice = newPrice.toFixed(1);
    product.save();
    console.log("zort")
    const productIdq = req.params.id;
    const wishlists = await wishlist.find({
      products: { $elemMatch: { productId: productIdq } },
    });
    
    if(req.body.discount > oldDiscount){
      for(let i = 0; i < wishlists.length; i++){
        userIdToNotify = wishlists[i].userId;
        console.log("userid: " + userIdToNotify);
        await emailer.notify(req.params.id, userIdToNotify);
      }
    }

    res.status(200).json({
      status: 'Success',
      data: {
        wishlists,
      },
    });
  } catch (err) {
    res.status(404).json({
      status: 'Fail',
      message: err,
    });
  }
};

// exports.discountProducts = async (req, res) => {
//   try {
//     const products = await Product.find();
//     console.log(products);
//     products.forEach(async (product) => {
//       product.discount = req.body.discount;
//       product.newPrice = product.price - product.price*product.discount/100;
//       product.save();
//     });
//     res.status(200).json({
//       status: 'Success',
//       data: {
//         products,
//       },
//     });
//   } catch (err) {
//     res.status(404).json({
//       status: 'Fail',
//       message: err,
//     });
//   }
// }
