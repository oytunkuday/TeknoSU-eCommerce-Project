<template>
  <h2>Complete Your Order</h2>
  <h3>Total: ${{ totalActual }}</h3>
  <div class="card">
    <div class="card-body">
      <div class="card-body">
        <h5 class="card-title">Bought Products:</h5>
        <vue-collapsible-panel>
          <template #title> </template>
          <template #content>
            <div v-for="prod in completeOrderList" :key="prod.productId">
              <div class="card">
                <div class="card-body">
                  <router-link
                    :to="{
                      name: 'ProductPage',
                      params: { id: prod.productId },
                    }"
                  >
                    <p class="card-title">
                      {{ prod.description
                      }}<!--{{ productMarket(product._id).name}}-->
                    </p>
                    <!-- <p class="card-text font-italic">
                    {{ product.description.substring(0, 65) }}...
                    </p> -->
                  </router-link>

                  <h6 class="card-text green">${{ prod.price }}</h6>
                  <h6 class="card-text">Amount: {{ prod.quantity }}</h6>
                </div>
              </div>
              <p class="card-title">{{ prod.name }}</p>
            </div>
          </template>
        </vue-collapsible-panel>
      </div>
    </div>
  </div>

  <form @submit.prevent="handleOrderComplete">
    <label>Your Name</label>
    <input required v-model="completeOrder.name" maxlength="30" />

    <label>Address</label>
    <input required v-model="completeOrder.address" />

    <label>Country</label>
    <input class="input2" required v-model="completeOrder.country" />

    <label>City</label>
    <input class="input2" required v-model="completeOrder.city" />

    <label>ZIP Code</label>
    <input class="input2" required v-model="completeOrder.zipCode" />

    <div class="submit">
      <button>Place your order</button>
    </div>
  </form>

  <div v-if="completed">
    <div class="overlay"></div>
    <div class="modal1">
      <h3>Order Completed! Your receipt has been sent to you via email.</h3>
      <router-link :to="{ name: 'ProfilePage' }">
        <button class="actions">Ok!</button>
      </router-link>
    </div>
  </div>
</template>

<script>
import axios from "axios";
import ProductBoxOrder from "../components/ProductBoxOrder.vue";
import { mapState } from "vuex";

export default {
    components:{ProductBoxOrder},
    //props: ["tP"],
    computed: {
        ...mapState(['user']),
        ...mapState(['userId']),
        ...mapState(['actualCart']),
        ...mapState(['completeOrderList']),
        ...mapState(['userToken']),
        ...mapState(['totalActual']),
        ...mapState(['cartTotal'])
    },
    data(){
        return{
            completeOrder: {
                user: '',
                name: '',
                products: [
                //     {
                //     quantity: 0,
                //     productId: '',
                //     description: '',
                //     price: 0
                // }
                ],
                address: '',
                city: '',
                country: '',
                paymentId: 'justWhateverMan',
                orderTotal: 0
            },
            completed: false
        }
    },

  methods: {
    handleOrderComplete() {
      this.completeOrder.user = this.user._id;
      this.completeOrder.products = this.completeOrderList;
      this.completeOrder.orderTotal = this.totalActual;

            console.log({"totalAct": this.totalActual})
            //console.log({"tP": this.tP})
            console.log({"orderTotal": this.completeOrder.orderTotal})
             axios.post('http://localhost:3000/api/v1/orders/complete', this.completeOrder,
             {
             headers: {
               'Content-Type': 'application/json',
               'Authorization': 'Bearer '+ this.userToken
            },
            })
             .then( response => 
              console.log(response),
              this.completed = true,
              this.$store.commit("onCompleteOrder")
             )
             .catch( error =>
              console.log(error)
             )
            console.log("order complete yay")
            console.log(this.actualCart)
        }
    },
  }
</script>

<style scoped>
/* {
    "user": "62758e08544c2c1728590bfd",
    "name": "Yigit Karamanli",
    "products": [{
        "quantity": 1,
        "productId:": "62777cdf30609860be925632",
        "description": "Apple iPhone 13 Pro Max 128 GB Midnight Black Mobile Phone",
        "price": 4999
         }],
    "address": "istanbul mahallesi istanbul sokak no:12",
    "zipCode": 34000,
    "city": "Istanbul",
    "country": "Turkey",
    "paymentId": "odedikistekardes"
} */
form {
  max-width: 700px;
  margin: 30px auto;
  background: rgb(255, 255, 255);
  text-align: left;
  padding: 30px;
  border-radius: 10px;
  width: 75%;
}
label {
  color: rgb(121, 114, 114);
  display: inline-block;
  margin: 25px 0 15px;
  font-size: 0.8rem;
  text-transform: uppercase;
  letter-spacing: 1px;
  font-weight: bold;
}
input {
  display: block;
  padding: 10px 6px;
  width: 100%;
  box-sizing: border-box;
  border: none;
  border-bottom: 1px solid #ddd;
  color: black;
}

.input2 {
  display: inline-block;
  width: 32%;
  margin: 15px;
}

.pill {
  display: inline-block;
  margin: 20px 10px 0 0;
  padding: 6px 12px;
  background: #eee;
  border-radius: 20px;
  font-size: 12px;
  letter-spacing: 1px;
  font-weight: bold;
  color: #777;
  cursor: pointer;
}
button {
  background: black;
  border: 0;
  width: 50%;
  padding: 10px 20px;
  margin-top: 20px;
  color: white;
  border-radius: 10px;
}
button:hover {
  cursor: pointer;
}
.submit {
  text-align: center;
}
.error {
  color: #fc1a2dce;
  margin-top: 10px;
  font-size: 0.8rem;
  font-weight: bold;
}
.modal1 {
  width: 50%;
  color: white;
  padding: 20px;
  margin: 10px auto;
  background: rgb(0, 0, 0);
  border-radius: 8px;
  position: fixed;
  z-index: 999;
  top: 20%;
  left: 25%;
  align-content: center;
  text-align: center;
  font-weight: bold;
  font-size: 20px;
}

.modal1 p {
  font-style: normal;
}

.modal1 .actions {
  font-style: oblique;
  text-align: center;
  margin: 20px 0 10px 0;
  color: rgb(0, 0, 0);
  padding: 8px;
  border: 1px solid rgb(223, 181, 181);
  border-radius: 4px;
  text-decoration: none;
  margin: 10px;
  width: 50%;
  background-color: rgb(255, 255, 255);
}

.modal1 .actions:hover {
  text-decoration: aqua;
  border: 2px solid rgb(0, 0, 0);
}

.overlay {
  position: fixed;
  left: 0;
  top: 0;
  width: 100vw;
  height: 100vh;
  display: block;
  background-color: #000;
  opacity: 0.5;
}
</style>
