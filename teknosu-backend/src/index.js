const mongoose = require('mongoose');
const dotenv = require('dotenv');

dotenv.config();
const app = require('./api/app');

const port = 3000;

const DB = process.env.DATABASE.replace(
  '<PASSWORD>',
  process.env.DATABASE_PASSWORD
);
//slmdeneme
mongoose
  .connect(DB, {
    useNewUrlParser: true,
    useCreateIndex: true,
    useFindAndModify: false,
    useUnifiedTopology: true,
  })
  .then(() => console.log('DB Connection established!'));

app.listen(port, () => {
  console.log(`App running on port: ${port}`);
});
