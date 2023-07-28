<template>
  <div v-if="error">{{error}}</div>
  <div v-if="product">
  
  <div class="card">
    <img :src="'https://'+imagedata" alt="Product Image" />
    <div class="card-body">
      
      <router-link :to="{name: 'ProductPage', params: {id: productorder.productId}}">
      
      <p class="card-title"> {{ product.name }}<!--{{ productMarket(product._id).name}}--></p>
      <!-- <p class="card-text font-italic">
        {{ product.description.substring(0, 65) }}...
      </p> -->
      
      </router-link>
     
      <h6 class="card-text green">${{ productorder.price }}</h6>
      <h6 class="card-text">Amount: {{ productorder.quantity }}</h6>
       <div v-if="order.status!='Cancelled' ">
       <router-link :to="{name: 'RatePage', params: {id: productorder.productId}}">
        
        <p class="card-text purple"> Rate this Product!</p>
        </router-link>

        <div v-if="orderproduct.refunded==='True'">
          <h6 class="card-text">Your refund request was approved. ${{ productorder.price*productorder.quantity }} was refunded.</h6>
        </div>
        <div v-else-if="orderproduct.refunded==='In Progress'">
          <h6 class="card-text">Your refund request is still in progress. ${{ productorder.price*productorder.quantity }} will be refunded.</h6>
        </div>
        <div v-else>
          <a href="#">
          <p class="card-text red"  id="refundtext" @click="refund()"> Refund this Product! (${{ productorder.price*productorder.quantity }} will be refunded.)</p></a>




        </div>
        
      </div>
     
     
     
     
    </div>
    
</div>

    <h6 class="card-title white">WQDQWDQWDQWDXQW</h6>
</div>


<div v-if="showModalCancel">
    <div class="overlay"></div>
    <div class="modal1">
       <p>Are you sure you want to refund this product?</p>
       
         <button class="actions" @click="realRefund()">Yes (${{ productorder.price*productorder.quantity }} to refunded)</button>
         <button class="actions" @click="refund()">No</button>
       
     </div>
     </div>
  <div v-else class="errorMsg">
        <h3>{{errorM}}</h3>
      </div>
</template>

<script>

import StarRating from 'vue-star-rating'
import getProduct from '../composables/getProduct'
import getImg from '../composables/getImg'
import getProducts from '../composables/getProducts'

import {mapState, useStore} from 'vuex' 
import axios from 'axios'

export default {
  props: ["productorder","theorder","theproductimg"],
  components: {StarRating},
  data() {
    return{
        orderproduct: this.productorder,
        order:this.theorder,
        showModalCancel: false,
        errorM: '',
        errorBoolean: false,
        productId1: this.product.productId,
        productdata: [],
        loading: true,
        errored: false,
        token: "",
        body:{
          productId:this.productorder.productId
        },
        imagedata: "https://e7.pngegg.com/pngimages/321/641/png-clipart-iphone-5s-ios-progress-bar-icon-load-the-map-loading-miscellaneous-tshirt.png",

    }
  },
  created(){
     axios.get("http://localhost:3000/api/v1/products/"+this.productorder.productId)
      .then(response => {this.imagedata=response.data.data.products.imgs[0]})
  },
  setup (props){
    const store = useStore()
    let token2 = store.state.signupResponse.token
    const uid = store.state.signupResponse.data.user._id
    
    const {products, error1, load} = getProducts()
    const{product, error, load8} = getProduct(props.productorder.productId)

    load()
    load8()
    console.log(products)
    console.log(product)
    console.log("image buyusu")
    console.log(props.productorder.productId)
    return {product, error, products, error1,uid, token2}
  },
  methods: {
    refreshData () {

      axios.get("http://localhost:3000/api/v1/orders/getOrderByUser?userid="+this.uid)
      .then(response => {
        console.log(response.data.data.orders.find( e => e._id ===this.order._id)),
        this.order = response.data.data.orders.find( e => e._id ===this.order._id),
        this.orderproduct = this.order.products.find( e => e.productId ===this.orderproduct.productId)
      }).catch(error => this.errorM=error, this.errorBoolean = true)
    
    },
    async waiter() {
      console.log('start timer');
      await new Promise(resolve => setTimeout(resolve, 350));
      this.refreshData()
    },
   refund(){
    this.showModalCancel= !this.showModalCancel;
   },
   realRefund(){
      console.log(this.token)
      this.token=this.token2
      this.showModalCancel= !this.showModalCancel;
      axios.patch('http://localhost:3000/api/v1/orders/refund/'+this.order._id, this.body,{
          headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer '+ this.token
          },
        }).then(response => console.log(response),
            this.showModalCancel = false)
        .catch(error => this.errorM=error, this.errorBoolean = true)
      
   
      this.waiter()
   }
  },

  computed: {
    ...mapState(['enableRemove']),
    ...mapState(['signedIn']),
    ...mapState(['userToken'])
  },
  
}

</script>

<style scoped>
.embed-responsive .card-img-top {
  object-fit: cover;
}

.card img {
    object-fit: scale-down;
    overflow: scroll;
    width: 100%;
    height: 10px;
    padding: 10px;
    margin: -2px;
    border-radius: 10px;
}
.card img:hover{
  padding: 5px;
}

a {
  text-decoration: none;
}
.card {
    text-align: center;
    background-color: #fefbfb;
    box-sizing: border-box;
    border: 1px solid rgba(0, 0, 0, 0.125);
    box-shadow: 0 4px 8px 0 rgba(0,0,0,0.2);
    border-radius: 100px;
    margin-bottom: -5px;
    display:flex;
    @media (min-width: 1500px) {
        max-width: 300px;
      }
}
.card:hover{
  box-shadow: 0 10px 15px 0 rgba(69, 51, 69, 0.32);
}
.card-title {
  color: #484848;
  font-size: 1.1rem;
  font-weight: 400;
}

.white{
  color: rgb(255, 255, 255);
}
.green{
  color: rgb(36, 122, 65);
}

.card-title:hover {
  font-weight: bold;
}

.everythingOnOneLine {
 white-space: nowrap;
}

.everythingOnOneLine * {
 display: inline;
}
.card-text {
  font-size: 1.0rem;
  margin: 10px;
}

.green{
  color: rgb(36, 122, 65);
}

.red{
  color: rgb(230, 60, 26);
}

#edit-product {
  float: right;
}

.button {
  display: inline-block;
  border-radius: 4px;
  background-color: #000000;
  border: none;
  color: #FFFFFF;
  text-align: center;
  font-size: 10px;
  padding: 10px;
  width: 60%;
  transition: all 0.5s;
  cursor: pointer;
  margin: 5px;
}


.button span {
  cursor: pointer;
  display: inline-block;
  position: relative;
  transition: 0.5s;
}

.button span:after {
  content: '\00bb';
  position: absolute;
  opacity: 0;
  top: 0;
  right: -20px;
  transition: 0.5s;
}

.button:hover span {
  padding-right: 25px;
}

.button:hover span:after {
  opacity: 1;
  right: 0;
}

.button1 {
  display: inline-block;
  border-radius: 4px;
  background-color: #000000;
  border: none;
  color: #FFFFFF;
  text-align: center;
  font-size: 10px;
  padding: 10px;
  width: 60%;
  transition: all 0.5s;
  cursor: pointer;
  margin: 5px;
  cursor: not-allowed;
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
 
     .modal1 .actions{
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

     .modal1 .actions:hover{
       text-decoration: aqua;
       border:2px solid rgb(0, 0, 0);
     }
.errorMsg{
       color: red;
     }
.overlay {
       position:fixed;
       left:0;
       top:0;
       width:100vw;
       height:100vh;
       display: block;
       background-color:#000;
       opacity:0.0;
    }
</style>