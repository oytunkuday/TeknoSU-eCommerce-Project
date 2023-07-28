<template>
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />

  <div class="row product-list">
    <masonry
      :cols="{ default: 4, 1000: 3, 700: 2, 400: 1 }"
      :gutter="{ default: '30px', 700: '20px' }"
    >
      <div class="column" v-for="product in products" :key="product._id">
        <product-box-sales-man
          :product="product"
          @select-card="selectProduct"
          @unselect-card="unselectProduct"
        />
      </div>
    </masonry>
  </div>
</template>

<script>
import ProductBoxSalesMan from "./ProductBoxSalesMan.vue";

export default {
  props: ["products"],
  components: { ProductBoxSalesMan },
  emits:['select-product','unselect-product'],
  data() {
    return {
      selectedProducts: [],
      //  mockCart: {
      //   productIDs: [],
      //   productNumber: 1
      // }
    };
  },
  methods: {
    selectProduct(prodId) {
      this.$emit('select-product', prodId)
    },
    unselectProduct(prodId) {
      this.$emit('unselect-product', prodId)
    },
  },
};
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

.product-list {
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
