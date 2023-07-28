import { ref } from "@vue/reactivity";
import axios from "axios";

const getUserOrders = (userId) => {
  const Orders = ref([]);
  const error = ref(null);
  const load666 = async () => {
    try {
      console.log(userId)
      let response = await axios.get(
        "http://localhost:3000/api/v1/orders/getOrderByUser?userid=" + userId+"&sort=createdAt");
        console.log(response);
        if (response.status === 200) {
        console.log("get orders complete");

        const data = response;
        console.log("31313131");
        console.log(response);
        Orders.value = data.data.data.orders;
        console.log(Orders);
        //console.log(Cart._rawValue.userId)
      } else if (response.status !== 200) {
        console.log("get orders NOT complete");
        throw Error("that post does no exist");
      }
    } catch (err) {
      console.log("orderalr cekilemedi");
      console.log(err);
    }
  };
  return {
    Orders,
    error,
    load666,
  };
};

export default getUserOrders;
