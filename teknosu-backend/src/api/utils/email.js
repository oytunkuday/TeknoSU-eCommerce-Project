const nodemailer = require('nodemailer');
const path = require('path');
const User = require('../models/userModel');
const Product = require('../models/productModel');


exports.sendEmail = async (fileName, user) => {
  // 1) Create a transporter
  const transporter = nodemailer.createTransport({
    host: 'smtp-relay.sendinblue.com', //your smtp host name
    // service: 'Gmail', // your service name
    port: 587,
    // secure: true, // true for 465, false for other ports
    auth: {
      user: 'gucluseviye@gmail.com',
      pass: 'DThZ8N5gkqAO3fJG', //TODO: change this
    },
    tls: {
      rejectUnauthorized: true,
    },
  });
  // 2) Define the email options


  const mailOptions = {
    from: '"TeknoSu" <teknosusabanci@gmail.com>',
    to: user.email,
    subject: 'Your TeknoSu Receipt',
    text: 'Your receipt is attached below',
    attachments: [
      {
        filename: fileName,
        path: path.join(`./receipts/${fileName}`),
        contentType: 'application/pdf',
      },
    ],
  };

  // 3) Actually send the email
  await transporter.sendMail(
    mailOptions,
    function (error, info) {
      if (error) {
        console.log(error);
      } else {
        console.log('Email sent: ' + info.response);
      }
    }
  );
};

exports.notify = async (message, user) => {
  // 1) Create a transporter
  const transporter = nodemailer.createTransport({
    host: 'smtp-relay.sendinblue.com', //your smtp host name
    // service: 'Gmail', // your service name
    port: 587,
    // secure: true, // true for 465, false for other ports
    auth: {
      user: 'gucluseviye@gmail.com',
      pass: 'DThZ8N5gkqAO3fJG', //TODO: change this
    },
    tls: {
      rejectUnauthorized: true,
    },
  });
  // 2) Define the email options

  const receipent = await User.findById(user);
  const product = await Product.findById(message);
  console.log(receipent.email)



  const mailOptions = {
    from: '"TeknoSu" <teknosusabanci@gmail.com>',
    to: receipent.email,
    subject: 'One of the items in your wishlist is on sale',
    text: product.name + ' is on sale, from ' + product.price + ' TL to ' + product.newPrice + ' TL',
    
  };

  // 3) Actually send the email
  await transporter.sendMail(
    mailOptions,
    function (error, info) {
      if (error) {
        console.log(error);
      } else {
        console.log('Email sent: ' + info.response);
      }
    }
  );
};

