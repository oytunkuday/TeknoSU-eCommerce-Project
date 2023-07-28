import { ref } from "@vue/reactivity";
import axios from "axios";

const getAllOrders = (token) => {
  const Orders = ref([]);
  const error = ref(null);
  const load661 = async () => {
    try {
      console.log("siktiret");
      let response = await axios.get(
        "http://localhost:3000/api/v1/orders",{
            headers: {
                authorization: 'Bearer '+ token,
                'Content-Type': 'application/json',
                },
        }
      );
      console.log(response);
      if (response.status === 200) {
        console.log("get orders complete");

        const data = response;
        console.log("ALLORDERSBRRRRRR");
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
    load661,
  };
};

export default getAllOrders;
