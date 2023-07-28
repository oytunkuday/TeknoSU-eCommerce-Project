const getOrder = async (orderId, token) => {
  try {
    let response = await fetch(
      `http://localhost:3000/api/v1/orders/${orderId}`,
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
    return responseData.data.orders;
  } catch (err) {
    console.log(err);
    // console.log(responseData.data.orders);
  }
};
export default getOrder;
