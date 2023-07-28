const getProfitBetweenDates = async (startDate, endDate, token) => {
  try {
    console.log(startDate);
    console.log(endDate);

    const data = {
      startDate: startDate,
      endDate: endDate,
    };
    let response = await fetch(
      `http://localhost:3000/api/v1/profit/betweenDates`,
      {
        method: "PATCH",
        headers: {
          "Content-Type": "application/json",
          Authorization: "Bearer " + token,
        },
        body: JSON.stringify(data),
      }
    );
    const responseData = await response.json();
    if (!response.ok) {
      const error = new Error(
        responseData.message || "Failed to get refund requests!"
      );
      throw error;
    }
    return responseData.data;
  } catch (err) {
    console.log(err);
  }
};
export default getProfitBetweenDates;
