<template>
  <div v-if="!signedIn">
    <h2>You are not signed in!</h2>
    <router-link to="/signin">Sign in here</router-link>
  </div>

  <div v-else>
    <h2 class="name">{{user.name}}</h2>
    <div class="info">
      <h3>Order Information</h3>
      
    </div>
    <!-- <div class="info">
      <h3>Review Purchased Products</h3>
      <div v-if="!ifPurchased">
        You have not bought/received a product from us yet..
        <a href="/">Start Shopping!!</a>
      </div>
      <div v-else></div>
    </div> -->
    <div><router-link to="/myOrders"><button>Check your previous orders here!</button></router-link></div>
    <div>
    <router-link to="/wishlist">
      <button>Your wishlist</button>
    </router-link>
    </div>
    <button class="btnRed" @click="handleLogOut">Log Out</button>

    <div v-if="userRole === 'salesManager'">
      <router-link to="/salesmanager">
        <button class="btnWhite">Sales Manager Page</button>
      </router-link>
    </div>
    
  </div>
</template>

<script>
import { mapState } from "vuex";
import pdfviewVue from "@/components/pdfview.vue";
export default {
  data() {
    return {
      ifPurchased: false,
      userRole : this.$store.state.user.role
    };
  },
  setup(props) {
    const ifSigned1 = props.success;

    return { ifSigned1 };
  },

  methods: {
    handleLogOut(){
      this.$store.commit('userOut')
    },
    printit(){
      console.log(this.userRole)
    }
  },

  computed: {
    ...mapState(['signedIn']),
    ...mapState(['user']),
  }
}
</script>

<style scoped>
  .name{
    color: rgb(29, 11, 46);
  }
  .info{
    color: black;
    text-align: middle;
    margin: 30px;
    left: 20px;
  }
  button {
      background: black;
      border: 0;
      width: 30%;
      padding: 10px 20px;
      margin-top: 20px;
      color: white;
      border-radius: 10px;
    }
    button:hover{
        cursor: pointer;
    }
  
  .btnRed:hover{
    background: rgb(144, 0, 0);
  }

  .btnWhite:hover{
    background: blue;
  }
</style>
