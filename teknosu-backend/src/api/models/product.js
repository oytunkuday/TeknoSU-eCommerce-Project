const products = [];

class Product {
  constructor(
    id,
    name,
    brand,
    category,
    description,
    distributor,
    price,
    stocks,
    isWarranty,
    isRecommended,
    isPopular,
    imageUrls
  ) {
    this.id = id;
    this.name = name;
    this.price = new Double(price);
    this.category = category;
    this.brand = brand;
    this.distributor = distributor;
    this.stocks = new Number(stocks);
    this.isWarranty = new Boolean(isWarranty);
    this.isRecommended = new Boolean(isRecommended);
    this.isPopular = new Boolean(isPopular);
    this.imageURLs = new Array(imageURLs);
    this.description = description;
  }

  save() {
    if (products === undefined || products === null) {
      this.id = 0;
    } else {
      this.id = products[products.length].id + 1;
    }
    products.push(this);
  }

  static findAll() {
    return products;
  }

  static findById(productId) {
    return products.filter((pdct) => pdct.id === productId);
  }

  update() {
    const index = products.findIndex(
      (pdct) => pdct.id === this.id
    );
    products[index] = this;
  }

  static deleteById(productId) {
    const index = products.findIndex(
      (pdct) => pdct.id === productId
    );
    products.splice(index, 1);
  }
}

module.exports = Product;
