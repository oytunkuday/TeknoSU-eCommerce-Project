<template>
  <div v-if="error">{{error}}</div>
  <div v-if="product">
    <div>
    <div>
      <h2>{{ product.name }}</h2>7
      <div>
        <img 
            :src="product.imgs[0]"
            alt="Product Image"
            class="image"/>
       <div> 
        <h4>About</h4>
        <p>
         {{ product.description}}
         </p>
         <p>Distributor: {{product.distributor}}</p>
         <p>{{product.stocks}} in stock</p>
       </div>  
      </div>
      <p></p>
      <h7 class="green">${{ product.price }}</h7>
      <button v-if="product.stocks === 0" class="button1" style="vertical-align:middle"><span>Out of Stock</span></button>
      <button @click="handleCart(product)" v-else-if="!enableRemove" class="button" style="vertical-align:middle"><span>Add to cart </span></button>
      <button @click="handleCart(product)" v-else-if="enableRemove" class="button" style="vertical-align:middle"><span>Remove from the cart </span></button>
    </div>
  </div>

  <div v-if="product.ratingsQuantity === 0" class="idkman">No ratings yet</div>
  <div v-else>Average rating: {{product.ratingsAvg}}/5
  <router-link :to="{name: 'Reviews', params: {_id: product._id}}">
  <button class="btn">See All Reviews</button>
  </router-link>
  </div>
  </div>

</template>

<script>

import getProduct from '../composables/getProduct' 
import {mapState} from 'vuex' 

export default {
    props:['id'],
    setup(props) {
        const{product, error, load8} = getProduct(props.id)

        load8()

        return{product, error}
    },
    methods: {  
    handleCart(product) {
    if(!this.signedIn){
     if(this.enableRemove){
       this.$store.commit('removeFrom', product._id)
       console.log(this.$store.state.mcProdIds)
     }
     else{
       this.$store.commit('addToMockCart', product._id)
     }
    }

    else{
      if(this.enableRemove){
        //remove from user shopping cart
        axios.post('http://localhost:3000/api/v1/cart/removeFromCart', this.body1,
         {
            headers: {
               'Content-Type': 'application/json',
               'Authorization': 'Bearer '+ this.userToken
             },
           })
             .then(response => console.log(response), 
             console.log("removed product!"),
             this.$store.commit('removeFromTotal', product.price),)
             .catch(error => console.log(error))
      }
      else{
      //add to user cart
        axios.post('http://localhost:3000/api/v1/cart/addToCart', this.body,
         {
            headers: {
               'Content-Type': 'application/json',
               'Authorization': 'Bearer '+ this.userToken
             },
           })
             .then(response => console.log(response), 
             console.log("added product!"),
             this.$store.commit('addToTotal', product.price),
             console.log(this.product._id))
             .catch(error => console.log(error))
        }
      console.log(this.body)
      console.log(this.userToken)
      }
     }
    },

    computed: {
    ...mapState(['enableRemove']),
    ...mapState(['signedIn']),
    ...mapState(['userToken'])
  }

}
</script>

<style scoped>
.image{
    width: 40%;
    height: auto;
    margin: 0;
    float: left;
    padding: 0 0;
}
.green{
    color: green;
    padding: 20px;
}
.button {
  display: inline-block;
  border-radius: 4px;
  background-color: #000000;
  border: none;
  width: 18%;
  color: #FFFFFF;
  text-align: center;
  font-size: 10px;
  padding: 10px;
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
  width: 30%;
  transition: all 0.5s;
  cursor: pointer;
  margin: 5px;
  cursor: not-allowed;
}
.btn {
  display: inline-block;
  border-radius: 4px;
  background-color: #000000;
  border: none;
  color: #FFFFFF;
  text-align: center;
  font-size: 10px;
  font-weight: bold;
  padding: 10px;
  width: 30%;
  transition: all 0.5s;
  cursor: pointer;
  margin: 20px;
}

.idkman{
  margin: 20px auto;
  font-size: 20px;
  font-weight: bold;
}
</style>