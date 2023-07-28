<template>
  <div v-if="!signedIn">
    <h2>You are not signed in!</h2>
    <router-link to="/signin">Sign in here</router-link>
  </div>
  
  <div v-else>
    <h2 class="name">Welcome to Order page</h2>
    <div class="info">
      <h3> Order Information </h3>
      <OrderList  :orders="Orders"/>
    </div>
  </div>
</template>

<script>
import OrderList from '../components/OrderList.vue'
import { mapState } from 'vuex'
import { useStore } from 'vuex'
import getUserOrders from '../composables/getUserOrders'

export default {
  name: 'MyOrders',
  components: {OrderList},
  data() {
  },
  computed: {
    ...mapState(['signedIn']),
    ...mapState(['userId']),
    ...mapState(['user']),
    ...mapState(['userToken'])
  },
  setup(){
    const store = useStore();
    
    if(store.state.signedIn){
      console.log("asdfg")
      console.log(store.state.userId)
      const {Orders, error, load666} = getUserOrders(store.state.user._id)
      load666()
      console.log(Orders)
      console.log(store.state.userId)
      return{Orders,error}
    }
  },
  
}
</script>

<style scoped>
  .name{
    color: rgb(29, 11, 46);
  }
  .info{
    text-align: left;
    left: 20px;
  }
</style>