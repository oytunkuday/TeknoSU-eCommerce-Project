<template>
    <!-- <h2>{{Wishlist}}</h2> -->
    <div v-if="!Wishlist.products.length">
        <h3>You have nothing in your wishlist. We can't notify you if you don't ask for it right</h3> 
    </div>

    <div v-else>
      <h2>We will notify you in case of a discount!</h2>
    <div v-for="product in products" :key="product" class="">
      <div v-for="wishPr in Wishlist.products" :key="wishPr">
        <div v-if="product._id === wishPr.productId" class="column">
          <ProductBox :product="product"/>
        </div>
      </div>
    </div> 
  </div>
</template>

<script>
import getWishlist from '../composables/getWishlist'
import getProducts from '../composables/getProducts'
import ProductBox from '../components/ProductBox.vue'
import {mapState, useStore} from 'vuex'

export default {
    components: {
        ProductBox,
        ...mapState(['userToken'])
    },

    setup(){
        const store = useStore()

        const {Wishlist, error, load18} = getWishlist(store.state.userToken)
        const {products, error1, load} = getProducts()

        load18()
        load()

        console.log(Wishlist)
        store.commit('setWishlist', Wishlist)
        return{Wishlist, error, products, error1}
    }   
}
</script>

<style>
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

@media screen and (max-width: 600px) {
  .column {
    width: 100%;
    display: block;
    margin-bottom: 20px;
  }
  .row {
    display: block;
  }
}
</style>