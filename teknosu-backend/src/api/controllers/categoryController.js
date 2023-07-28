const Category = require('../models/categoryModel');
const Product = require('../models/productModel');
const APIFeatures = require('../helpers/apiFeatures');
//

exports.getAllCategories = async (req, res) => {
  try {
    const features = new APIFeatures(
      Category.find(),
      req.query
    )
      .filter()
      .sort()
      .limitFields()
      .paginate();
    const categories = await features.query;

    //SEND RESPONSE
    res.status(200).json({
      status: 'success',
      results: categories.length,
      data: {
        categories,
      },
    });
  } catch (err) {
    res.status(404).json({
      status: 'Fail',
      message: err,
    });
  }
};

exports.getActiveCategories = async (req, res) => {
  try {
    const features = new APIFeatures(
      Category.find({ status: 'active' }),
      req.query
    )
      .filter()
      .sort()
      .limitFields()
      .paginate();
    const categories = await features.query;

    //SEND RESPONSE
    res.status(200).json({
      status: 'success',
      results: categories.length,
      data: {
        categories,
      },
    });
  } catch (err) {
    res.status(404).json({
      status: 'Fail',
      message: err,
    });
  }
};

exports.getCategory = async (req, res) => {
  try {
    const category = await Category.findById(req.params.id);
    // Category.findOne({ _id: req.params.id })

    res.status(200).json({
      status: 'success',
      data: {
        categories: category,
      },
    });
  } catch (err) {
    res.status(404).json({
      status: 'Fail',
      message: err,
    });
  }
};

exports.createCategory = async (req, res) => {
  try {
    console.log('burdayim');
    const newCategory = await Category.create(req.body);

    res.status(201).json({
      status: 'success',
      data: {
        category: newCategory,
      },
    });
  } catch (err) {
    res.status(400).json({
      status: 'Fail',
      message: err,
    });
  }
};

exports.updateCategory = async (req, res) => {
  try {
    const category = await Category.findByIdAndUpdate(
      req.params.id,
      req.body,
      { new: true, runValidators: true }
    );

    res.status(200).json({
      status: 'Success',
      data: {
        category,
      },
    });
  } catch (err) {
    res.status(404).json({
      status: 'Fail',
      message: err,
    });
  }
};

exports.deleteCategory = async (req, res) => {
  try {
    //FIXER
    // const categories = await Category.find();
    // for(let i = 0; i < categories.length; i++){
    //   categories[i].status = 'active';
    //   categories[i].save();
    // }
    toDelete = await Category.findById(req.params.id);

    const products = await Product.find();
    for (let i = 0; i < products.length; i++) {
      if (
        products[i].category.toString() === toDelete.name
      ) {
        console.log(products[i]);
        products[i].status = 'passive';
        products[i].save();
      }
    }

    toDelete.status = 'passive';
    toDelete.save();

    res.status(204).json({
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

exports.activateCategory = async (req, res) => {
  try {
    const category = await Category.findById(req.params.id);
    category.status = 'active';
    category.save();

    const products = await Product.find({
      category: category.name,
    });
    for (let i = 0; i < products.length; i++) {
      products[i].status = 'active';
      products[i].save();
    }
    res.status(200).json({
      status: 'Success',
      data: category,
    });
  } catch (err) {
    res.status(400).json({
      status: 'Fail',
      message: err,
    });
  }
};
