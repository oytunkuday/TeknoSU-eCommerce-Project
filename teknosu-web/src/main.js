import { createApp } from "vue";
import "devextreme/dist/css/dx.light.css";
import App from "./App.vue";
import router from "./router";
import axios from "axios";
import BootstrapVue from "bootstrap-vue";
import "bootstrap/dist/css/bootstrap.min.css";
import "bootstrap-vue/dist/bootstrap-vue.css";
import { createStore } from "vuex";
import vue3StarRatings from "vue3-star-ratings";
import StarRating from "vue-star-rating";
import VueCollapsiblePanel from "@dafcoe/vue-collapsible-panel";
const store = createStore({
  state() {
    return {
      productCount: 0,
      mcProdIds: [],
      userToken: "",
      userId: "",
      user: {},
      cartProducts: [],
      signedIn: false,
      enableRemove: false,
      cartTotal: 0,
      actualCart: [],
      currentProduct: {
        quantity: 0,
        productId: "",
        description: "",
        price: 0,
      },
      completeOrderList: [],
      signupResponse: {},
      wishlist: {},
      inWishlist: false,
      totalActual: 0,
    };
  },
  mutations: {
    addToMockCart(state, prID) {
      state.productCount++;
      state.mcProdIds.push(prID);
    },
    removeFrom(state, prID) {
      state.productCount--;
      state.mcProdIds.pop(prID);
    },
    handleToken(state, token) {
      state.userToken = token;
    },
    handleRemove(state) {
      state.enableRemove = true;
    },
    handleAdd(state) {
      state.enableRemove = false;
    },
    userIn(state) {
      state.signedIn = true;
    },
    userOut(state) {
      state.signupResponse = {};
      state.signedIn = false;
      state.user = {};
      state.wishlist = {};
      state.userToken = "";
      state.userId = "";
      state.cartTotal = 0;
      state.totalActual = 0;
      state.actualCart = [];
      state.cartProducts = [];
      state.completeOrderList = [];
    },
    setUser(state, userInf) {
      state.user = userInf;
    },
    setUserID(state, _id) {
      state.userId = _id;
    },
    setUserProducts(state, products) {
      state.cartProducts = products;
    },
    addToTotal(state, pricing) {
      state.cartTotal += pricing;
    },
    removeFromTotal(state, pricing) {
      state.cartTotal -= pricing;
    },
    addToActualCart(state, prod) {
      state.actualCart = prod;
    },
    addToOrderList(state, prod) {
      state.completeOrderList.push(prod);
    },
    currentQ(state, q) {
      state.currentProduct.quantity = q;
    },
    currentId(state, _id) {
      state.currentProduct.productId = _id;
    },
    currentDes(state, des) {
      state.currentProduct.description = des;
    },
    currentP(state, pr) {
      state.currentProduct.price = pr;
    },
    setSignUp(state, su) {
      state.signupResponse = su;
    },
    setWishlist(state, wL) {
      state.wishlist = wL;
    },
    setStatusWishlistTrue(state) {
      state.inWishlist = true;
    },
    setStatusWishlistFalse(state) {
      state.inWishlist = false;
    },
    setTotal(state, total) {
      state.totalActual = total;
    },

    onCompleteOrder(state){
      state.cartProducts = []
      state.cartTotal = 0
      state.actualCart = []
      state.completeOrderList = []
      state.totalActual = 0
    },

    initialiseStore(state) {
      // Check if the ID exists
      if (localStorage.getItem("store")) {
        // Replace the state object with the stored item
        this.replaceState(
          Object.assign(state, JSON.parse(localStorage.getItem("store")))
        );
      }
    },
  },
});
store.subscribe((mutation, state) => {
  // Store the state object as a JSON string
  localStorage.setItem("store", JSON.stringify(state));
});

const app = createApp(App).use(router).use(store).use(VueCollapsiblePanel);
app.config.globalProperties.axios = axios;
app.component("vue3-star-ratings", vue3StarRatings);

app.component("star-rating", StarRating.default);
app.mount("#app");
