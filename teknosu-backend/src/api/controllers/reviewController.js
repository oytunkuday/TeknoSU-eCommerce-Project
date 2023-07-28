const Review = require('../models/reviewModel');
const Product = require('../models/productModel');
const APIFeatures = require('../helpers/apiFeatures');
//

exports.getAllReviews = async (req, res) => {
  try {
    console.log(req.query)
    const features = new APIFeatures(
      Review.find(),
      req.query
    )
      .filter()
      .sort()
      .limitFields()
      .paginate();
    const reviews = await features.query;

    //SEND RESPONSE
    res.status(200).json({
      status: 'success',
      results: reviews.length,
      data: {
        reviews,
      },
    });
  } catch (err) {
    res.status(404).json({
      status: 'Fail',
      message: err,
    });
  }
};

exports.getReview = async (req, res) => {
  try {
    const review = await Review.findById(req.params.id);
    // Review.findOne({ _id: req.params.id })

    res.status(200).json({
      status: 'success',
      data: {
        reviews: review,
      },
    });
  } catch (err) {
    res.status(404).json({
      status: 'Fail',
      message: err,
    });
  }
};

exports.createReview = async (req, res) => {
  try {
    const newReview = await Review.create(req.body);
    res.status(201).json({
      status: 'success',
      data: {
        review: newReview,
      },
    });
  } catch (err) {
    res.status(400).json({
      status: 'Fail',
      message: err,
    });
  }
};

exports.updateReview = async (req, res, next) => {
  try {
    await Review.findByIdAndUpdate(
      req.params.id,
      req.body,
      { new: true, runValidators: true }
    );
    // res.status(200).json({
    //   status: 'Success',
    //   data: {
    //     review,
    //   },
    // });
    next();
  } catch (err) {
    res.status(404).json({
      status: 'Fail',
      message: err,
    });
  }
};
exports.changeAverageRating = async (req, res) => {
  try {
    const review = await Review.findById(req.params.id);
    // const pname = await Product.findById(review.product)
    //   .name;
    const allreviews = await Review.find({
      product: review.product,
    });

    let totalRating = 0;
    allreviews.forEach((element) => {
      totalRating += element.rating;
    });
    const averageRating = totalRating / allreviews.length;
    const product = await Product.findOneAndUpdate(
      { _id: review.product },
      {
        ratingsAvg: averageRating,
        $inc: { ratingsQuantity: 1 },
      },
      { new: true, runValidators: true }
    );
    console.log(product);
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

exports.deleteReview = async (req, res) => {
  try {
    await Review.findByIdAndDelete(req.params.id);
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
