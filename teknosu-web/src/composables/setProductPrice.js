const setProductPrice = async (id, price, token) => {
  try {
    console.log(id);
    console.log(price);
    console.log(token);
    const data = {
      price: price,
    };
    let response = await fetch(`http://localhost:3000/api/v1/products/${id}`, {
      method: "PATCH",
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer " + token,
      },
      body: JSON.stringify(data),
    });
    console.log(response);
  } catch (err) {
    console.log(err);
  }
};
export default setProductPrice;
