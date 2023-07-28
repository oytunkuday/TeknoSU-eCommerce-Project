const rejectRefund = async (orderId, productId, token) => {
  try {
    const data = {
      productId: productId,
    };
    let response = await fetch(
      `http://localhost:3000/api/v1/orders/rejectRefund/${orderId}`,
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
export default rejectRefund;
