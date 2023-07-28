const setDiscount = async (product, discountAmount, token) => {
  try {
    console.log(product);
    console.log(discountAmount);
    const data = {
      discount: discountAmount,
    };
    let response = await fetch(
      `http://localhost:3000/api/v1/products/discount/${product}`,
      {
        method: "PATCH",
        headers: {
          "Content-Type": "application/json",
          Authorization: "Bearer " + token,
        },
        body: JSON.stringify(data),
      }
    );
    console.log(response);
  } catch (err) {
    console.log(err);
  }
};
export default setDiscount;
