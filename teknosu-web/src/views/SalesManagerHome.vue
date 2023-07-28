<template>
  <div id="home">
    <div v-if="selectedProducts.length > 0">
      <h2>Enter Discount Amount</h2>
      <form @submit="discountProducts">
        <input
          type="number"
          placeholder="Discount Amount"
          v-model="discountAmount"
        />
        <div>
          <button>Set Discount</button>
        </div>
      </form>
    </div>

    <div>
      <h2>Products</h2>
      <div class="btn">
        <label>Sort:&nbsp;&nbsp;</label>
        <select v-model="sort" class="selection">
          <option class="options" value="recommended">Recommended</option>
          <option class="options" value="ascending">
            Sort in Ascending Price
          </option>
          <option class="options" value="descending">
            Sort in Descending Price
          </option>
          <option class="options" value="ascendingR">
            Sort in Ascending Rating
          </option>
          <option class="options" value="descendingR">
            Sort in Descending Rating
          </option>
          <option class="options" value="mostselling">
            Sort in for Most Selling
          </option>
        </select>
      </div>
    </div>

    <div v-if="sort === 'recommended'">
      <div v-if="products.length">
        <ProductListSalesMan
          :products="products"
          @select-product="selectProd"
          @unselect-product="unselectProd"
        />
      </div>
    </div>
    <div v-else-if="sort === 'ascending'">
      <ProductListSalesMan
        :products="productsSorted"
        @select-product="selectProd"
        @unselect-product="unselectProd"
      />
    </div>
    <div v-else-if="sort === 'descending'">
      <ProductListSalesMan
        :products="productsSortedDes"
        @select-product="selectProd"
        @unselect-product="unselectProd"
      />
    </div>
    <div v-else-if="sort === 'descendingR'">
      <ProductListSalesMan
        :products="productsSortedRatingDes"
        @select-product="selectProd"
        @unselect-product="unselectProd"
      />
    </div>
    <div v-else-if="sort === 'ascendingR'">
      <ProductListSalesMan
        :products="productsSortedRating"
        @select-product="selectProd"
        @unselect-product="unselectProd"
      />
    </div>
    <div v-else-if="sort === 'mostselling'">
      <ProductListSalesMan
        :products="productsSortedSold"
        @select-product="selectProd"
        @unselect-product="unselectProd"
      />
    </div>
  </div>
</template>

<script>
import ProductListSalesMan from "../components/ProductListSalesMan.vue";
import getProducts from "../composables/getProducts";
import getCategories from "../composables/getCategories";
import Carousel from "../components/carousel/Carousel";
import getSortedProducts from "../composables/getSortedProducts";
import getSortedProductsDes from "../composables/getSortedProductsDes";
import getSortedProductsRatingDes from "../composables/getSortedProductsRatingDes";
import getSortedProductsRating from "../composables/getSortedProductsRating";
import getSortedProductsSold from "../composables/getSortedProductsSold";
import setDiscount from "../composables/setDiscount";

export default {
  name: "HomeView",
  components: { ProductListSalesMan, Carousel },
  setup() {
    const { products, error, load } = getProducts();
    console.log(products);
    const { Categories, error1, load1 } = getCategories();
    const { productsSorted, error2, load3 } = getSortedProducts();
    const { productsSortedDes, error3, load5 } = getSortedProductsDes();
    const { productsSortedRating, error4, load66 } = getSortedProductsRating();
    const { productsSortedRatingDes, error5, load77 } =
      getSortedProductsRatingDes();
    const { productsSortedSold, error6, load88 } = getSortedProductsSold();

    load();
    load1();
    load3();
    load5();
    load66();
    load77();
    load88();

    return {
      products,
      error,
      Categories,
      error1,
      productsSorted,
      error2,
      productsSortedDes,
      error3,
      productsSortedRating,
      error4,
      productsSortedRatingDes,
      error5,
      productsSortedSold,
      error6,
    };
  },
  data: () => ({
    searchKey: "",
    sort: "recommended",
    selectedProducts: [],
    discountAmount: null,
  }),
  methods: {
    async discountProducts() {
      console.log("discounting");
      const products = this.selectedProducts;
      for (var i = 0; i < products.length; i++) {
        await setDiscount(
          products[i],
          this.discountAmount,
          this.$store.state.userToken
        );
      }
      console.log("Finito");
    },
    selectProd(prodId) {
      this.selectedProducts.push(prodId);
    },
    unselectProd(prodId) {
      const prodIndex = this.selectedProducts.findIndex((el) => {
        return el === prodId;
      });
      this.selectedProducts.splice(prodIndex, 1);
    },
    printSelected() {
      console.log(this.selectedProducts);
    },
    getKey() {
      console.log("hello");
      console.log(this.searchKey);
    },
    handleSort() {
      this.sorted = !this.sorted;
    },
  },
};
</script>

<style scoped>
.faint {
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
  font-family: "Roboto", sans-serif;
  font-weight: 400;
  opacity: 0.8;
  font-family: "Josefin Sans", sans-serif;
}
#content {
  opacity: 0.8;
}
h2 {
  font-family: "Josefin Sans", sans-serif;
}

.searchInput {
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
  color: #ffffff;
  text-align: center;
  font-size: 15px;
  padding: 3px;
  width: 30%;
  transition: all 0.5s;
  cursor: pointer;
  margin: 5px;
}
.btn {
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
.options {
  font-style: bold;
  color: white;
  background-color: black;
  padding: 10px;
  margin: 10px 10px;
  border-radius: 2px;
}
</style>
