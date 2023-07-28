//prop infos

function getCategoryPropsData() {
  return {
    Category: {
      name: "Phones",
      photo:
        "https://st-troy.mncdn.com/mnresize/1500/1500/Content/media/ProductImg/original/mlpf3tua-apple-iphone-13-128gb-gece-yarisi-637678210553548502.jpg",
      status: "active",
      _id: "624db5909132a416b3c043ba",
    },
  };
}
function getProductPropsData() {
  return {
    product: {
      _id: "629b542069c943966631f7df",
      description:
        "Trade in your eligible computer for credit toward a new MacBook Pro. P...",
      distributor: "Apple Turkey",
      stocks: 1,
      recommended: true,
      popular: true,
      imgs: ["https://i.imgur.com/G1VcuhT.jpeg"],
      ratingsQuantity: 2,
      sold: 6,
      discount: 20,
      newPrice: 12800,
      name: "Macbook Pro 16inch 16GB RAM 512GB SSD",
      brand: "Apple",
      category: "Computers",
      cost: 8000,
      price: 16000,
      warranty: true,
      ratingsAvg: 3.0,
      __v: 0,
      createdAt: "2022-06-08T08:51:03.586+00:00",
      status: "active",
    },
  };
}

function getProductOrderData() {
  return {
    productorder: {
      "tax-rate": 0,
      refunded: "False",
      _id: "629d19b5b5434d3f384b031f",
      quantity: 1,
      productId: "629b542069c943966631f7df",
      price: 16000,
      description:
        "Trade in your eligible computer for credit toward a new MacBook Pro. Personal setup available. Select a model or customize your own.",
    },
    theorder: {
      status: "Processing",
      _id: "629d19b5b5434d3f384b031e",
    },
    theproductimg: {},
  };
}

function getSoldoutProductPropsData() {
  return {
    product: {
      _id: "629b542069c943966631f7df",
      description:
        "Trade in your eligible computer for credit toward a new MacBook Pro. P...",
      distributor: "Apple Turkey",
      stocks: 0,
      recommended: true,
      popular: true,
      imgs: ["https://i.imgur.com/G1VcuhT.jpeg"],
      ratingsQuantity: 2,
      sold: 6,
      discount: 20,
      newPrice: 12800,
      name: "Macbook Pro 16inch 16GB RAM 512GB SSD",
      brand: "Apple",
      category: "Computers",
      cost: 8000,
      price: 16000,
      warranty: true,
      ratingsAvg: 3.0,
      __v: 0,
      createdAt: "2022-06-08T08:51:03.586+00:00",
      status: "active",
    },
  };
}

function getOrderBoxData(){
  return{
    order:{
      _id:"62ab2a916ccc05375cd62a97",
      deliveryid: "62ab2a916ccc05375cd62a97",
      status: "Processing",
      user: "629de5c5af3f7922e8ee66bb",
      name: "Oytun",
      address:"evadresim",
      products: [],
      city:"Istanbul",
      country:"Turkey",
      paymentId:"randompaymentid",
      orderTotal:0,
      zipCode:32111,
      createdAt:"2022-06-16T13:05:21.980+00:00"
    }
  }
}

export {
  getCategoryPropsData,
  getProductPropsData,
  getSoldoutProductPropsData,
  getProductOrderData,
  getOrderBoxData
};
