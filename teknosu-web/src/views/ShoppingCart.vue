<template>
<div v-if="!signedIn">
<div v-if="mcProdIds.length">
  <div v-for="product in products" :key="product" class="column">
      <div v-for="prodID in mcProdIds" :key="prodID">
        <div v-if="product._id === prodID" class="row">
          <ProductBox :product="product"/>
        </div>
      </div>
  </div>
  <div>
    <h3>You have to be logged in to complete an order!</h3>
  </div>
  </div>
  <div v-else>
   <h3>You have nothing in your shopping cart yet :(</h3>
  </div>
</div>

<div v-else>
  <div v-if="Cart.cart.products.length">
    <div class="">
    <div v-for="product in products" :key="product" class="">
      <div v-for="cartPr in Cart.cart.products" :key="cartPr">
        <div v-if="product._id === cartPr.productId" class="column">
          <ProductBox :product="product"/>
          <div class="card">
            <span align="center"> <button @click="remove(cartPr)">-</button><h2>Quantity: {{cartPr.quantity}}</h2><button @click="add(cartPr.productId,1,product.name,product.price)">+</button>
          </span>
             </div>
          
          
        </div>
      </div>
    </div> 
    </div>
    <div>
        <button @click="waiter()">Refresh cart</button>
      <router-link :to="{name: 'CreditCard'}">
        <button @click="runThis(Cart)">Complete Order (${{Cart.totalprice}})</button>
      </router-link>
    </div>
  </div>

  <div v-else>
   <h3>As a user, you have nothing in your shopping cart yet :(</h3>
  </div>
  
    <!-- <div v-if="Cart.products.length">
    <div v-for="product in products" :key="product" class="column">
      <div v-for="cartPr in Cart.products" :key="cartPr">
        <div v-if="product._id === cartPr.productId" class="row">
          <h2>{{product.price}}</h2>
        </div>
      </div>
    </div> 
  </div> -->
  
</div>
</template>

<script>
import axios from 'axios'
import ProductBox from '../components/ProductBox.vue'
import getProducts from '../composables/getProducts'
import getUserCart from '../composables/getUserCart'
import getProduct from '../composables/getProduct'
import { mapState } from 'vuex'
import { useStore } from 'vuex'
import { watch } from '@vue/runtime-core'

export default {
    components:{ProductBox},

  //   watch: {
  //   key: {
  //     load1() {},
  //     flush: 'post'
  //   }
  // },

    setup(){
      const {products, error, load} = getProducts()
      load()

      const store = useStore()
      //const token1 = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjYyNmU4OTU3NTA5MjFmMDczNTI3Njg0OCIsImlhdCI6MTY1MjA4NjkxMSwiZXhwIjoxNjU5ODYyOTExfQ.LRLATPMqbizpMS7qOc7H4cuzk68Ff1kIn5AqLvkLjPY"
      if(store.state.signedIn){
        
        const {Cart, error1, load1} = getUserCart(store.state.userToken)
        var userTokenof = store.state.signupResponse.token
        load1()
        //store.commit("setTotal", Cart.totalPrice)
        console.log({Cart: Cart})

        // console.log("whattt")
        // console.log(Cart)

        // for(pr in Cart.data.products){
        //   const{product, error} = getProduct(pr.productId)
        //   load()
        //   currentProduct.quantity = pr.quantity
        //   currentProduct.productId = pr.productId
        //   currentProduct.description = product.description
        //   console.log("just please")
        //   currentProduct.quantity = product.price
        //   // this.$store.commit('currentQ', pr.quantity)
        //   // this.$store.commit('currentP', product.price)
        //   // this.$store.commit('currentDes', product.description)
        //   // this.$store.commit('currentId', pr.productId)
        //   this.$store.commit('addToOrderList', currentProduct)
        // }
        return{userTokenof,Cart, error1, products, error}
      
      }
      return{products, error}
    
    },
    computed: {
      ...mapState(['productCount']),
      ...mapState(['mcProdIds']),
      ...mapState(['enableRemove']),
      ...mapState(['signedIn']),
      ...mapState(['userToken']),
      ...mapState(['cartTotal']),
      ...mapState(['actualCart']),
      // ...mapState(['currentProduct'])
    },

    methods: {
      refreshData () {
        console.log('in refreshdata')
    axios.get("http://localhost:3000/api/v1/cart/getCart",{
            headers: {
                authorization: 'Bearer '+ this.userTokenof,
                'Content-Type': 'application/json',
                }})
      .then(response => {
        console.log(response),
        this.Cart = response.data
      }).catch(console.log('sad'))
    
    },async waiter() {
      console.log('start timer');
      await new Promise(resolve => setTimeout(resolve, 800));
      this.refreshData()
    },

    add(id,quantity,name,price){
      axios
            .post("http://localhost:3000/api/v1/cart/addToCart", {"productId": id, "quantity": quantity, "name": name, "price": price}, {
              headers: {
                "Content-Type": "application/json",
                Authorization: "Bearer " + this.userTokenof,
              },
            })
            .then(
              (response) => console.log(response),
              console.log("added product!"),
              
            )
            .catch((error) => console.log(error));
      this.waiter()
    },

    remove(prod){
      axios
            .post(
              "http://localhost:3000/api/v1/cart/removeFromCart",
              {"productId": prod.productId},
              {
                headers: {
                  "Content-Type": "application/json",
                  Authorization: "Bearer " + this.userTokenof,
                },
              }
            )
            .then(
              (response) => console.log(response),
              console.log("removed product!"),
              this.$store.commit("removeFromTotal", prod.price)
            )
            .catch((error) => console.log(error));
      this.waiter()
    },
      runThis(cart1){
        console.log({"runThis ran": cart1.totalprice})
        this.$store.commit('addToActualCart', cart1.cart.products),
        this.$store.commit('setTotal', cart1.totalprice)
        // let currentProduct = {
        //         quantity: 0,
        //         productId: '',
        //         description: '',
        //         price: 0
        // }
        // let i = 0,
        // len = this.actualCart.length;

        // for(; i < len ; i++){
        //   console.log(this.actualCart[i])
        //   currentProduct.quantity = this.actualCart[i].quantity,
        //   currentProduct.productId = this.actualCart[i].productId,

        //   axios.get("http://localhost:3000/api/v1/products/" + this.actualCart[i].productId)
        //     .then(response => currentProduct.price = response.data.data.products.price
        //             );
        //   axios.get("http://localhost:3000/api/v1/products/" + this.actualCart[i].productId)
        //     .then(response => currentProduct.description = response.data.data.products.description
        //             );
           
        //    this.$store.commit('addToOrderList', currentProduct)
        //  }
        this.waiter()
      }
    }

}
</script>

<style scoped>
.column {
  float: left;
  width: 25%;
  padding: 10px 10px;
}

.row {
    margin: 0 -1px;
    height: 30%;
    }

.row:after {
  content: "";
  display: table;
  clear: both;
}

.product-list{
    background: rgba(252, 243, 250, 0.502);
    flex-direction: column;
    align-items: center;
}

button {
  display: inline-block;
  border-radius: 4px;
  background-color: #000000;
  border: none;
  color: #FFFFFF;
  text-align: center;
  font-size: 15px;
  padding: 10px;
  width: 30%;
  transition: all 0.5s;
  cursor: pointer;
  margin: 35px;
}


@media screen and (max-width: 600px) {
  .column {
    width: 100%;
    display: block;
    margin-bottom: 20px;
  }
  .row {
    display: grid;
  }
}
</style>