<template>
  <h3>Your total is ${{totalActual}}</h3>
  
  <form @submit.prevent="handleOrder">
      <label>Card Number</label>
      <input required v-model="card.cardNumber"
       maxlength="16">

      <label>Date</label>
      <input class="input2" required v-model="card.date"
      maxlength="5">

      <label>Cvv</label>
      <input class="input2" required v-model="card.cvv"
      maxlength="3">

      <div class="submit">
        <button>Confirm credit card</button>
      </div>
  </form>
  
  <div v-if="open">
    <div class="overlay"></div>
    <div  class="modal1">
    <p>Valid Card!  Proceed?</p>
    <button class="actions" @click="open = false">No</button>
    <router-link :to="{name: 'OrderPage'}">
    <button class="actions" @click="open = false">Yes</button>
    </router-link>
    </div>
  </div>
<!-- <Teleport to="body">
  <div v-if="open" class="modal">
    <p>Valid Card!  Proceed?</p>
    <button class="actions" @click="open = false">No</button>
    <router-link :to="{name: 'OrderPage'}">
    <button class="actions" @click="open = false">Yes</button>
    </router-link>
  </div>
</Teleport> -->

</template>

<script>
import {mapState} from 'vuex'
import axios from 'axios'

export default {
    props: ['tP'],
    computed: {
        ...mapState(['cartTotal']),
        ...mapState(['completeOrderList']),
        ...mapState(['actualCart']),
        ...mapState(['currentProduct']),
        ...mapState(['totalActual'])
        // formatCard() {
        //     let nn = this.card.cardNumber;
        //     (nn.length - (nn.split(" ").length - 1)) % 4 === 0 ? this.card.cardNumber += ' ' : ''
        // }
    },
    data() {
        return{
            showModal: false,
            open: false,
            card: {
                cardNumber: '',
                date: '',
                cvv: ''
            },
            
        }
    },

    methods: {
        handleOrder(){
            console.log("card submitted")
            this.showModal = !this.showModal
            this.open = !this.open
            let i = 0,

        len = this.actualCart.length;

        for(; i < len ; i++){

          let crrPr = {
            quantity : 0,
            productId: '',
            price : 0,
            description : '',

          }
          console.log(this.actualCart[i])
          this.$store.commit('currentQ', this.actualCart[i].quantity)
          this.$store.commit('currentId', this.actualCart[i].productId)

          crrPr.quantity = this.actualCart[i].quantity,
          crrPr.productId = this.actualCart[i].productId,

          axios.get("http://localhost:3000/api/v1/products/" + this.actualCart[i].productId)
            .then(response => crrPr.price = response.data.data.products.newPrice
            //this.$store.commit('currentP', response.data.data.products.price)
            //currentProduct.price = response.data.data.products.price
                    );
          axios.get("http://localhost:3000/api/v1/products/" + this.actualCart[i].productId)
            .then(response => crrPr.description = response.data.data.products.name
            //this.$store.commit('currentDes', response.data.data.products.description)
            //currentProduct.description = response.data.data.products.description
                    );
           console.log(crrPr)
           this.$store.commit('addToOrderList', crrPr)
           console.log(this.completeOrderList)
           
           
         }
        },
        closeModal(){
          this.open = false
        }
    }
}
</script>

<style scoped>
    form {
      max-width: 700px;
      margin: 30px auto;
      background: rgb(255, 255, 255);
      text-align: left;
      padding: 40px;
      border-radius: 10px;
      width: 70%;
    }
    label {
        color: rgb(121, 114, 114);
        display: inline-block;
        margin: 25px 0 15px;
        font-size: 0.8rem;
        text-transform: uppercase;
        letter-spacing: 1px;
        font-weight: bold;
    }
    input {
        display: block;
        padding: 10px 6px;
        width: 100%;
        box-sizing: border-box;
        border: none;
        border-bottom: 1px solid #ddd;
        color: black;
    }

    .input2 {
        display: inline-block;
        width: 35%;
        margin: 15px;
    }

    .pill {
      display: inline-block;
      margin: 20px 10px 0 0;
      padding: 6px 12px;
      background: #eee;
      border-radius: 20px;
      font-size: 12px;
      letter-spacing: 1px;
      font-weight: bold;
      color: #777;
      cursor: pointer;
    }
    button {
      background: black;
      border: 0;
      width: 50%;
      padding: 10px 20px;
      margin-top: 20px;
      color: white;
      border-radius: 10px;
    }
    button:hover{
        cursor: pointer;
    }
    .submit {
      text-align: center;
    }
    .error {
      color: #fc1a2dce;
      margin-top: 10px;
      font-size: 0.8rem;
      font-weight: bold;
    }

    .modal1 {
        width: 50%;
        color: white;
        padding: 20px;
        margin: 10px auto;
        background: rgb(0, 0, 0);
        border-radius: 8px;
        position: fixed;
        z-index: 999; 
        top: 20%;
        left: 25%;
        align-content: center;
        text-align: center;
        font-weight: bold;
        font-size: 20px;
    }

    .backdrop {
        top: 0;
        position: fixed;
        background: rgba(0, 0, 0, 0.5);
        width: 100%;
        height: 100%;
    }
    .modal1 h1 {
        color: #76a1e2;
        border: none;
        padding: 0;
    }

    .modal1 p {
        font-style: normal;
    }

    .modal1 .actions{
        font-style: oblique;
        text-align: center;
        margin: 20px 0 10px 0;
        color: rgb(0, 0, 0);
        padding: 8px;
        border: 1px solid rgb(223, 181, 181);
        border-radius: 4px;
        text-decoration: none;
        margin: 10px;
        width: 20%;
        background-color: rgb(255, 255, 255);
    }
    .modal1 .actions:hover{
       text-decoration: aqua;
       border:2px solid rgb(0, 0, 0);
     }
     
     .overlay {
       position:fixed;
       left:0;
       top:0;
       width:100vw;
       height:100vh;
       display: block;
       background-color:#000;
       opacity:0.5;
    }
</style>