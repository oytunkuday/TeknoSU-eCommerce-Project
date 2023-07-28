<template>
  <div id="home">
    <form>
      <input type="text" v-model="searchKey"  placeholder="Search for a product..." @keyup.enter="getKey"/>
      <div v-if="searchKey"><router-link :to="{name: 'Search', params:{searchKey: this.searchKey}}"><button>Search</button></router-link></div>
    </form>
    <div>
      <h2>Top Categories</h2>
      <Carousel :slides="slides" :interval="3000" controls indicators></Carousel>
    </div>
    
    <h5 class="seperator">-------------</h5>
   
    <div>
      <h2>Top Products</h2>
      <h4 class="faint">Best sellers across categories..
        <div class="btn">
        <label>Sort:&nbsp;&nbsp;</label>
        <select v-model="sort" class="selection">
          <option class="options" value="recommended">Recommended</option> 
          <option class="options" value="ascending">Sort in Ascending Price</option>
          <option class="options" value="descending">Sort in Descending Price</option>
          <option class="options" value="ascendingR">Sort in Ascending Rating</option>
          <option class="options" value="descendingR">Sort in Descending Rating</option>
          <option class="options" value="mostselling">Sort in for Most Selling</option>
      </select>
        </div>
      </h4>
    </div>

    <div v-if="sort === 'recommended'">
    <div v-if="products.length">
      <ProductList  :products="products"/>
    </div>
    </div>
    <div v-else-if="sort === 'ascending'">
      <ProductList  :products="productsSorted"/>
    </div>
    <div v-else-if="sort === 'descending'">
      <ProductList  :products="productsSortedDes"/>
    </div>
    <div v-else-if="sort === 'descendingR'">
      <ProductList  :products="productsSortedRatingDes"/>
    </div>
    <div v-else-if="sort === 'ascendingR'">
      <ProductList  :products="productsSortedRating"/>
    </div>
    <div v-else-if="sort === 'mostselling'">
      <ProductList  :products="productsSortedSold"/>
    </div>
  </div>

</template>

<script>

import ProductList from '../components/ProductList.vue'
import getProducts from '../composables/getProducts'
import getCategories from '../composables/getCategories'
import Carousel from '../components/carousel/Carousel'
import getSortedProducts from '../composables/getSortedProducts'
import getSortedProductsDes from '../composables/getSortedProductsDes'
import getSortedProductsRatingDes from '../composables/getSortedProductsRatingDes'
import getSortedProductsRating from '../composables/getSortedProductsRating'
import getSortedProductsSold from '../composables/getSortedProductsSold'

export default {
  name: 'HomeView',
  components: {ProductList, Carousel},
  setup(){
    const {products, error, load} = getProducts()
    console.log(products)
    const {Categories, error1, load1} = getCategories()
    const {productsSorted, error2, load3} = getSortedProducts()
    const {productsSortedDes, error3, load5} = getSortedProductsDes()
    const {productsSortedRating, error4, load66} = getSortedProductsRating()
    const {productsSortedRatingDes, error5, load77} = getSortedProductsRatingDes()
    const {productsSortedSold, error6, load88} = getSortedProductsSold()
    
    load()
    load1()
    load3()
    load5()
    load66()
    load77()
    load88()

    return {products, error, Categories, error1, productsSorted, error2, productsSortedDes, error3,productsSortedRating,error4,productsSortedRatingDes, error5,productsSortedSold, error6}
  },
  data: () => ({
    slides: [
      "https://www.cnet.com/a/img/resize/eabd239642878785575800cb4b1a52ee4ccc1bc9/2020/08/18/b7168aea-9f7e-47bb-9f31-4cb8ad92fbc7/lg-note-20-ultra-5g-iphone-11-se-google-pixel-4a-lg-velvet-6133.jpg?auto=webp&fit=crop&height=630&width=1200",
      "https://i.insider.com/624f09923f392a00193f4e2f?width=1136&format=jpeg",
    ],
    searchKey: '',
    sort: "recommended"
  }),
  methods: {
    getKey() {
      console.log("hello")
      console.log(this.searchKey)
    },
    handleSort(){
      this.sorted = !this.sorted
    }
}
  
}
</script>

<style scoped>
.faint{
  color: rgba(22, 22, 31, 0.728);
}
.page-holder {
    min-height: 100;
  }
  .bg-cover {
    background-size: cover !important;
  }
  #background-div {
    background: rgb(255, 255, 255);
  }
  #heading {
    text-decoration: none;
    font-family: 'Roboto', sans-serif;
    font-weight: 400;
    opacity: 0.8;
    font-family: 'Josefin Sans', sans-serif;
  }
  #content {
    opacity: 0.8;
  }
  h2 {
    font-family: 'Josefin Sans', sans-serif;
  }

  input {
  display: block;
  width: 90%;
  margin: 20px auto;
  padding: 10px 45px;
  background: white url("../assets/search-icon.svg") no-repeat 15px center;
  background-size: 15px 15px;
  font-size: 20px;
  border: none;
  border-radius: 5px;
  box-shadow: rgba(50, 50, 93, 0.25) 0px 2px 5px -1px,
    rgba(0, 0, 0, 0.3) 0px 1px 3px -1px;
} 
.seperator h5 {
  display: flex;
  justify-content: center;
  align-items: center;
  padding: 0 1em;
}

button {
  display: inline-block;
  border-radius: 4px;
  background-color: #000000;
  border: none;
  color: #FFFFFF;
  text-align: center;
  font-size: 15px;
  padding: 3px;
  width: 30%;
  transition: all 0.5s;
  cursor: pointer;
  margin: 0px;
}
.btn{
  display: inline-block;
  border-radius: 3px;
  border: none;
  color: #000000;
  text-align: center;
  font-size: 15px;
  padding: 0px;
  width: 20%;
  transition: all 0.5s;
  cursor: pointer;
  margin-left: 25%;
}
.options{
        font-style: bold;
        color: white;
        background-color: black;
        padding: 10px;
        margin: 10px 10px;
        border-radius: 2px;
    }
</style>
