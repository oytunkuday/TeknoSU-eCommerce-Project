<template>
  <form>
      <input type="text" v-model="searchKey"  placeholder="Search for a product..." @keyup.enter="getKey"/>
      <div v-if="searchKey"><router-link :to="{name: 'Search', params:{searchKey: this.searchKey}}"><button>Search</button></router-link></div>
    </form>

  <div v-if="Category">
    <div>
    <h1>{{Category.name}}</h1>
    <div>
      <h2>Top Products</h2>
      <h4 class="faint">Best {{Category.name}} to spend your earnings on!...
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


    <div v-if="products">
        <div class="product-list">
      <div class="" v-if="sort === 'recommended'">
      <div v-for="product in products" :key="product._id" class="">
       <div v-if="product.category === Category.name" class="column">
          <ProductBox :product="product"/>
        </div>
        </div>
    </div>
    <div v-else-if="sort === 'ascending'">
      <div v-for="product in productsSorted" :key="product._id" class="">
       <div v-if="product.category === Category.name" class="column">
          <ProductBox :product="product"/>
        </div>
        </div>

    </div>
    <div v-else-if="sort === 'descending'">
      <div v-for="product in productsSortedDes" :key="product._id" class="">
       <div v-if="product.category === Category.name" class="column">
          <ProductBox :product="product"/>
        </div>
        </div>
    </div>

    <div v-else-if="sort === 'descendingR'">
      <div v-for="product in productsSortedRatingDes" :key="product._id" class="">
       <div v-if="product.category === Category.name" class="column">
          <ProductBox :product="product"/>
        </div>
        </div>
    </div>

    <div v-else-if="sort === 'ascendingR'">
      <div v-for="product in productsSortedRating" :key="product._id" class="">
       <div v-if="product.category === Category.name" class="column">
          <ProductBox :product="product"/>
        </div>
        </div>
    </div>
    
    <div v-else-if="sort === 'mostselling'">
      <div v-for="product in productsSortedSold" :key="product._id" class="">
       <div v-if="product.category === Category.name" class="column">
          <ProductBox :product="product"/>
        </div>
        </div>
    </div>

      </div>    
    </div>
    
    
    </div>

  
  
</div>
  
  

</template>

<script>
import getCategory from '../composables/getCategory'
import getProducts from '../composables/getProducts'
import ProductBox from '../components/ProductBox.vue'
import ProductList from '../components/ProductList.vue'
import getSortedProducts from '../composables/getSortedProducts'
import getSortedProductsDes from '../composables/getSortedProductsDes'
import getSortedProductsRatingDes from '../composables/getSortedProductsRatingDes'
import getSortedProductsRating from '../composables/getSortedProductsRating'
import getSortedProductsSold from '../composables/getSortedProductsSold'

export default {
    props:['_id'],
    components: {ProductBox, ProductList},
    setup(props) {
        const{Category, error, load1} = getCategory(props._id)
        const {products, error1, load} = getProducts()
        const {productsSorted, error2, load3} = getSortedProducts()
        const {productsSortedDes, error3, load5} = getSortedProductsDes()
        const {productsSortedRating, error4, load66} = getSortedProductsRating()
        const {productsSortedRatingDes, error5, load77} = getSortedProductsRatingDes()
        const {productsSortedSold, error6, load88} = getSortedProductsSold()
        load1()
        load()
        load3()
        load5()
        load66()
        load77()
        load88()
        console.log("cat")
        console.log(productsSortedSold)
        return{Category, error, products, error1, productsSorted, error2, productsSortedDes, error3,productsSortedRating,error4,productsSortedRatingDes, error5,productsSortedSold, error6}
    },
    data(){
      return{
        searchKey: '',
        sort: "recommended"
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