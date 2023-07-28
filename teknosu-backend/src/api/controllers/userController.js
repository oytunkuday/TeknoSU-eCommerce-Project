const User = require('./../models/userModel');
const APIFeatures = require('../helpers/apiFeatures');
const catchAsync = require('./../utils/catchAsync');

/*
exports.getAllUsers = (req, res) => {
    res.status(500).json({
      status: 'error',
      message: 'This route is not yet defined!'
    });
  };
*/

// exports.getAllUsers = catchAsync(async (req, res, next) => {
//   try {
//     const features = new APIFeatures(User.find(), req.query)
//       .filter()
//       .sort()
//       .limitFields()
//       .paginate();
//     const users = await features.query;

//     //SEND RESPONSE
//     res.status(200).json({
//       status: 'success',
//       results: users.length,
//       data: {
//         users,
//       },
//     });
//   } catch (err) {
//     res.status(404).json({
//       status: 'Fail',
//       message: err,
//     });
//   }
// });

exports.getAllUsers = async (req, res) => {
  try {
    const features = new APIFeatures(User.find(), req.query)
      .filter()
      .sort()
      .limitFields()
      .paginate();
    const users = await features.query;

    //SEND RESPONSE
    res.status(200).json({
      status: 'success',
      results: users.length,
      data: {
        users,
      },
    });
  } catch (err) {
    res.status(404).json({
      status: 'Fail',
      message: err,
    });
  }
};

exports.getUserOrder = async (_id) => {
  try {
    const user = await User.findById(_id);
    if (user === null) {
      throw ``;
    }
    return user;
  } catch (err) {
    console.log('error');
  }
};

exports.getUser = async (req, res) => {
  try {
    const user = await User.findById(req.id);
    if (user === null) {
      throw ``;
    }
    res.status(200).json({
      status: 'Success',
      id: user._id,
      email: user.email,
      name: user.name,
      role: user.role,
    });
  } catch (err) {
    res.status(500).json({
      status: 'Failed',
      message: err,
    });
  }
};
exports.createUser = (req, res) => {
  res.status(500).json({
    status: 'error2',
    message: 'This route is not yet defined!',
  });
};
exports.updateUser = async (req, res) => {
  try {
    const user = await User.findByIdAndUpdate(
      req.params.id,
      req.body,
      {
        new: true,
        runValidators: true,
      }
    );
    res.status(200).json({
      status: 'Success',
      data: {
        user,
      },
    });
  } catch (err) {
    res.status(400).json({
      status: 'Fail',
      message: err,
    });
  }
};

exports.deleteUser = async (req, res) => {
  try {
    await User.findByIdAndDelete(req.params.id);
    res.status(204).json({
      status: 'Success',
      data: req,
    });
  } catch (err) {
    res.status(400).json({
      status: 'Fail',
      message: err,
    });
  }
};
