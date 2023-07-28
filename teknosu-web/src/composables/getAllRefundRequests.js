const getAllRefundRequests = async (token) => {
  try {
    let response = await fetch(
      "http://127.0.0.1:3000/api/v1/orders/refunds/getAllRefundRequests",
      {
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

    // console.log(responseData);
    const refundReqs = [];

    for (const elem in responseData.data.refundRequests) {
      const request = {
        orderId: responseData.data.refundRequests[elem].orderId,
        productId: responseData.data.refundRequests[elem].productId,
      };
      refundReqs.push(request);
    }
    // console.log(refundReqs);
    return refundReqs;
  } catch (err) {
    console.log(err);
  }
};
export default getAllRefundRequests;
