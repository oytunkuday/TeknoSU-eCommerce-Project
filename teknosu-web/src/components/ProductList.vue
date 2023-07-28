<template>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">

  <div class="row product-list">
    <masonry
      :cols="{default: 4, 1000: 3, 700: 2, 400: 1}"
      :gutter="{default: '30px', 700: '20px'}"
      >
      <div class="column" v-for="product in products" :key="product._id">

            <ProductBox :product="product"/>
       
      </div>
    </masonry>
  </div>
</template>

<script>
import ProductBox from './ProductBox.vue'

export default {
    props: ['products'],
    components: {ProductBox},
    // data() {
    //  return{
    //    mockCart: {
    //     productIDs: [],
    //     productNumber: 1
    //   }
    //  }
    // }
}
</script>

<style>

.column {
  float: left;
  width: 55%;
  padding: 1px 1px;
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