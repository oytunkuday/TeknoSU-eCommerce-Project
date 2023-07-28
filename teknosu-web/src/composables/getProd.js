const getProd = async (productId, token) => {
  try {
    let response = await fetch(
      `http://localhost:3000/api/v1/products/${productId}`,
      {
        method: "GET",
        headers: {
          Authorization: "Bearer " + token,
        },
      }
    );
    const responseData = await response.json();
    if (!response.ok) {
      const error = new Error(
        responseData.message || "Failed to get refund requests!"
      );
      throw error;
    }
    // console.log(responseData.data.products);
    return responseData.data.products
  } catch (err) {
    console.log(err);
  }
};
export default getProd;
