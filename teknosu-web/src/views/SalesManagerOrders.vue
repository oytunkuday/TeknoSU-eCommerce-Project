<template>
  <div v-if="!signedIn">
    <h2>You are not signed in!</h2>
    <router-link to="/signin">Sign in here</router-link>
  </div>
  
  <div v-else>
    <h2 class="name">All Orders Page</h2>
    <div class="info">
      <h3> Order Information </h3>
      <OrderListP  :orders="Orders"/>
    </div>
  </div>
</template>

<script>
import OrderListP from '../components/OrderListP.vue'
import { mapState } from 'vuex'
import { useStore } from 'vuex'
import getAllOrders from '../composables/getAllOrders'
import {
  VueCollapsiblePanelGroup,
  VueCollapsiblePanel,
} from '@dafcoe/vue-collapsible-panel'
export default {
  name: 'AllOrders',
  components: {OrderListP},
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
    console.log(store.state.signupResponse)
    var tokenn = store.state.signupResponse.token
    console.log("asdfg")
    console.log(store.state.userId)
    const {Orders, error, load661} = getAllOrders(tokenn)
    load661()
    console.log(Orders)

    console.log("saaas")
    console.log(Orders)
    return{Orders,error}
    }
  
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