<template>
  <div v-if="page" class="header">
    <router-link to="/" class="logo" @click="this.$store.commit('handleAdd')"
      >TeknoSU</router-link
    >
    <div class="header-right header">
      <router-link to="/categories" @click="this.$store.commit('handleAdd')"
        >Categories</router-link
      >
      <router-link
        to="/ShoppingCart"
        @click="this.$store.commit('handleRemove')"
        >Shopping Cart</router-link
      >
      <router-link to="/myProfile" @click="this.$store.commit('handleAdd')"
        >Profile</router-link
      >
    </div>
  </div>
  <div v-else class="header">
    <router-link
      to="/salesmanager"
      class="logo"
      @click="this.$store.commit('handleAdd')"
      >TeknoSU Sales Manager</router-link
    >
    <div class="header-right header">
      <router-link to="/salesmanager" @click="this.$store.commit('handleAdd')"
        >Sales Manager Home</router-link
      >
      <router-link
        to="/salesmanrefundrequests"
        @click="this.$store.commit('handleAdd')"
        >Refund Requests</router-link
      >
      <router-link to="/profitpage" @click="this.$store.commit('handleAdd')"
        >Profits</router-link
      >
      <router-link
        to="/salesmanagerorders"
        @click="this.$store.commit('handleAdd')"
        >Orders</router-link
      >
      <router-link to="/" @click="this.$store.commit('handleAdd')"
        >User Site</router-link
      >
    </div>
  </div>
  <router-view />
  <div class="footer">
    <Footer />
  </div>
</template>

<script>
import Footer from "./components/Footer.vue";

export default {
  beforeMount() {
    this.$store.commit("initialiseStore");
  },
  components: { Footer },
  computed: {
    page() {
      return (
        this.$route.name !== "SalesManagerHome" &&
        this.$route.name !== "RefundRequests" &&
        this.$route.name !== "Profit" &&
        this.$route.name !== "SalesManagerOrders"
      );
    },
  },
};
</script>

<style>
* {
  box-sizing: border-box;
}

#app {
  font-family: Avenir, Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
}

body {
  padding: 0px;
  margin: 0;
}

nav {
  padding: 30px;
}

nav a {
  font-weight: bold;
  color: #334456;
}

nav a.router-link-exact-active {
  color: #42b983;
}

.footer {
  position: fixed;
  bottom: 0;
  left: 0;
  width: 100%;
  height: 3rem;
}

.header {
  background-color: black;
  overflow: hidden;
  padding: 7px 10px;
}
.header-right {
  float: right;
}

.header a.logo {
  font-size: 37px;
  font-weight: bold;
  color: whitesmoke;
}
.header a.logo:hover {
  font-size: 40px;
  font-weight: bolder;
  color: whitesmoke;
  background-color: black;
}

.header a:hover {
  background-color: rgb(103, 101, 101);
  color: rgb(44, 40, 40);
}

.header a {
  float: left;
  color: whitesmoke;
  text-align: center;
  padding: 12px;
  text-decoration: none;
  font-size: 18px;
  line-height: 25px;
  border-radius: 4px;
}
.header a:hover {
  background-color: #ddd;
  color: black;
}
.header a.active {
  background-color: dodgerblue;
  color: white;
}
@media screen and (max-width: 500px) {
  .header a {
    float: none;
    display: block;
    text-align: left;
  }
  .header-right {
    float: none;
  }
}
</style>
