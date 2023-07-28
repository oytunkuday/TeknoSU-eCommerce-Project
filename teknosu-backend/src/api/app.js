const express = require('express');
const morgan = require('morgan');
const cors = require('cors');
const cookieParser = require('cookie-parser');
const productRouter = require('./routes/productRoutes');
const categoryRouter = require('./routes/categoryRoutes');
const reviewRouter = require('./routes/reviewRoutes');
const AppError = require('./utils/appError');
const globalErrorHandler = require('./controllers/errorController');
const userRouter = require('./routes/userRoutes');
const shoppingCartRouter = require('./routes/shoppingCartRoutes');
const orderRouter = require('./routes/orderRoutes');
const wishlistRouter = require('./routes/wishlistRoutes');
const profitRouter = require('./routes/profitRoutes');

const app = express();

app.use(
  cors({
    origin: '*',
  })
);
app.use(morgan('dev'));
app.use(express.json());
//app.use(express.static('${__dirname}/public'));

//?????
app.use((req, res, next) => {
  req.requestTime = new Date().toISOString();
  next();
});

app.use('/api/v1/products', productRouter);
app.use('/api/v1/categories', categoryRouter);
app.use('/api/v1/reviews', reviewRouter);
app.use('/api/v1/users', userRouter);
app.use('/api/v1/orders', orderRouter);
app.use('/api/v1/cart', shoppingCartRouter);
app.use('/api/v1/wishlist', wishlistRouter);
app.use('/api/v1/profit', profitRouter);
app.all('*', (req, res, next) => {
  // const err = new Error(`${req.originalUrl} not found`);
  // err.status = 'fail';
  // err.statusCode = 404;

  next(new AppError(`${req.originalUrl} not found`, 404));
});

// app.use((err, req, res, next) => {
//   console.log(err.stack);

//   err.statusCode = err.statusCode || 500;
//   err.status = err.status || 'error';

//   res.status(err.statusCode).json({
//     status: err.status,
//     message: err.message,
//   });
// });

app.use(globalErrorHandler);

module.exports = app;
