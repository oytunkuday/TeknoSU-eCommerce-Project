<template>
  <div v-if="!Result.length" class="errMsg">
    Sorry!! There are no results for "{{searchKey}}" 
    <div><router-link to="/"> <button>Go back to home page?</button> </router-link></div>
  </div>
  <div v-else>
      <div class="together">
        <h2>Search results for "{{searchKey}}"</h2>
          <!-- <div class="btn">
          <div v-if="!sorted"><button @click="handleSort" >Sort by Price</button></div>
          <div v-else><button @click="handleSort">Recommended</button></div>
          </div> -->
          <div>
          <label>Sort:&nbsp;&nbsp;</label>
          <select v-model="sort" class="selection">
          <option class="options" value="recommended">Recommended</option> 
          <option class="options" value="ascending">Sort in Ascending Order</option>
          <option class="options" value="descending">Sort in Descending Order</option>
      </select>
      </div>
        
      </div>

     <div v-if="sort === 'recommended'">
      <ProductList  :products="Result"/>
     </div>
     <div v-else-if="sort === 'ascending'">
      <ProductList  :products="ResultSorted"/>
     </div>
     <div v-else-if="sort === 'descending'">
      <ProductList  :products="ResultSortedDes"/>
     </div>
  </div>
</template>

<script>

import getSearchResult from '../composables/getSearchResult'
import getSortedSearchResult from '../composables/getSortedSearchResult'
import getSortedSearchResultDes from '../composables/getSortedSearchResultDes'
import ProductBox from '../components/ProductBox.vue'
import ProductList from '../components/ProductList.vue'

export default {
    props: ["searchKey"],

    components:{ProductBox, ProductList},

    data: () => ({ 
      sort: 'recommended'
    }),

    setup(props) {
        const{Result, error, load2} = getSearchResult(props.searchKey)
        const{ResultSorted, error1, load4} = getSortedSearchResult(props.searchKey)
        const{ResultSortedDes, error2, load6} = getSortedSearchResultDes(props.searchKey)

        load2()
        load4()
        load6()

        return{Result, error, ResultSorted, error1, ResultSortedDes, error2}
    }
}
</script>

<style scoped>

.errMsg{
  font-size: 25px;
  margin: 20px auto;
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
  width: 20%;
  transition: all 0.5s;
  cursor: pointer;
  margin: 10px;
}
.together{
  align-content: center;
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