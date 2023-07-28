<template>
    <div class="card">
    <div class="card-body">
       <div v-if="order.status=== 'Processing'">
      <p align="right">
      <p class="myButton" @click="cancelOrder()">Cancel Order</p>
      </p>
      </div>
      <div v-else>
      <p class="card-tit"></p>
      </div>
      <p class="card-title">Order No: {{ order._id }}</p>
      <p class="date">Order date: {{ order.createdAt.substr(0,10) +" " +order.createdAt.substr(11,5) }}</p>
     

      <p class="date">Order Status: {{ order.status}}</p>
      <p class="date">Address: {{ order.address}}</p>
      <p class="card-text"> Total Price: ${{calculatetotalprice(order)}}</p>   
        <div class="card-body">
          
          <p class="card-title">Bought Products:</p>
           <vue-collapsible-panel :expanded="false">
        <template #title>
            
        </template>
        <template #content>
            <div v-for="prod in order.products" :key="prod._id">
            <ProductBoxOrder :productorder="prod" :theorder="order" :theproductimg="imgData(prod)"/>
            <!--<div>{{imgData(prod)}}</div>--->
            <!--<img class="card-img" :src="imgData(prod)" alt="Product Image" />--->
            
            
          </div>
        </template>
    </vue-collapsible-panel>
          
        </div>
        <div> </div>
      <!-- <p class="card-text font-italic">
        {{ product.description.substring(0, 65) }}...
      </p> -->
      
       <!-- 
           <h6 class="card-text green">${{ Order.newPrice }}</h6>
           <button v-if="product.stocks === 0" class="button1" style="vertical-align:middle"><span>Out of Stock</span></button>
      <button @click="handleCart(product)" v-else-if="!enableRemove" class="button" style="vertical-align:middle"><span>Add to cart </span></button>
      <button @click="handleCart(product)" v-else-if="enableRemove" class="button" style="vertical-align:middle"><span>Remove from the cart </span></button>-->
    </div>
  </div>
  <div v-if="showModalCancel">
    <div class="overlay"></div>
    <div class="modal1">
       <p>Are you sure you want to cancel this order?</p>
       
         <button class="actions" @click="realCancelOrder()">Yes (${{calculatetotalprice(order)}} to refunded)</button>
         <button class="actions" @click="cancelOrder()">No</button>
       
     </div>
     </div>
  <div v-else class="errorMsg">
        <h3>{{errorM}}</h3>
      </div>

</template>

<script>

import {mapState, useStore} from 'vuex' 
import axios from 'axios'
import ProductList from '../components/ProductList.vue'
import ProductBoxOrder from './ProductBoxOrder.vue'
import {
  VueCollapsiblePanelGroup,
  VueCollapsiblePanel,
} from '@dafcoe/vue-collapsible-panel'
export default {
  components: {ProductList,ProductBoxOrder,VueCollapsiblePanelGroup,
  VueCollapsiblePanel,},
  props: ["order"],
  data() {
    return{
      order: this.order,
      body: {
        OrderId: this.order._id,
        Products: this.order.products,
        showSection: true, 
      },
      showModalCancel: false,
      errorM: '',
      errorBoolean: false,
      token: "",
      body2: {
        status: "Cancelled"
      },
    }
  },

  setup(props){
    const store = useStore()
    let token2 = store.state.signupResponse.token
    console.log("sadasdasdasetup")
    const uid = store.state.signupResponse.data.user._id
    console.log(store.state.signupResponse.data.user)
    return{uid, token2}
  },
  methods: {
    refreshData () {

    axios.get("http://localhost:3000/api/v1/orders/getOrderByUser?userid="+this.uid)
      .then(response => {
        console.log(response.data.data.orders.find( e => e._id ===this.order._id)),
        this.order = response.data.data.orders.find( e => e._id ===this.order._id)
      }).catch(error => this.errorM=error, this.errorBoolean = true)
    
    },
    async imgData (produ) {
    
    const data = await axios.get("http://localhost:3000/api/v1/products/"+produ.productId)
      .then(response => {response.data.data.products.imgs[0]}).catch(error => this.errorM=error, this.errorBoolean = true)
      console.log(data)
      return data
    },
    cancelOrder(){
            
            this.showModalCancel= !this.showModalCancel;
            
        },
    async waiter() {
      console.log('start timer');
      await new Promise(resolve => setTimeout(resolve, 800));
      this.refreshData()
    },
    realCancelOrder (){
      console.log(this.token)
      this.token=this.token2
      this.showModalCancel= !this.showModalCancel;
      axios.patch('http://localhost:3000/api/v1/orders/'+this.order._id, this.body2,{
          headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer '+ this.token
          },
        }).then(response => console.log(response),
            this.showModalCancel = false)
        .catch(error => this.errorM=error, this.errorBoolean = true)
      
   
      this.waiter()

    },
    toggle() {
     this.showSection = !this.showSection
    },
    calculatetotalprice(order){
      let totalprice =0
      console.log("COME HERE")
      order.products.forEach((p)=>totalprice += p.price * p.quantity)
      console.log(totalprice)
      return totalprice
    }
  
  },

  computed: {
    ...mapState(['signedIn']),
    ...mapState(['userToken']),
    ...mapState(['signupResponse'])
  },
  watch: {
    token: function (newValue, oldValue) {
      console.log(newValue)
      console.log("YOLOOOOO")
      // here you can do whatever you want
    }
  }

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
    height: 400px;
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
    padding: 1px;
    margin: auto;
    width: 93%;
    text-align: center;
    background-color: #fefbfb;
    box-sizing: border-box;
    overflow:auto;
    border: 1px solid rgba(0, 0, 0, 0.125);
    box-shadow: 0 4px 8px 0 rgba(0,0,0,0.2);
    border-radius: 30px;
    
    margin-bottom: 20px;
    @media (min-width: 150px) {
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

.card-tit {
  text-align: right;
  color: #484848;
  font-size: 1.1rem;
  font-weight: 400;
}
.green{
  color: rgb(36, 122, 65);
}

.red{
  color: rgb(230, 60, 26);
}
.card-title:hover {
  font-weight: bold;
}
.card-text {
  font-size: 1.0rem;
  margin: 10px;
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


.myButton {
  
	box-shadow:inset 0px 39px 0px -24px #e67a73;
	background-color:#e4685d;
	border-radius:4px;
	border:1px solid #ffffff;
	display:inline-block;
	cursor:pointer;
	color:#ffffff;
	font-family:Arial;
	font-size:15px;
	padding:6px 15px;
	text-decoration:none;
	text-shadow:0px 1px 0px #b23e35;
  float:inline-start;
}
.myButton:hover {
	background-color:#eb675e;
}
.myButton:active {
	position:relative;
	top:1px;
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