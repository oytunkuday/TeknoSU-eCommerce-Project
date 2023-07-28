<template>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">

  <div class="row product-list">
    <masonry
      :rows="{default: 4, 1000: 3, 700: 2, 400: 1}"
      :gutter="{default: '30px', 700: '20px'}"
      >
      <div class="row" v-for="order in orders" :key="order.createdAt">
          <OrderBox :order="order"/>
      </div>
    </masonry>
  </div>
</template>

<script>
import OrderBox from './OrderBox.vue'

export default {
    props: ['orders'],
    components: {OrderBox},
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
    flex-direction: row;
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