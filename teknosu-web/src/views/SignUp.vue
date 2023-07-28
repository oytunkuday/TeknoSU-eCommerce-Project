<template>
   <form @submit.prevent="handleSubmit">
       <label>Name:</label>
       <input type="text" required v-model="signUp.name">
 
       <label>Email:</label>
       <input type="email" required v-model="signUp.email">
 
       <label>Password:</label>
       <input type="password" required v-model="signUp.password">
       <!-- <div class="error" v-if="passwordError">{{passwordError}} </div> -->
 
       <label>Password Again:</label>
       <input type="password1" required v-model="signUp.passwordConfirm">
 
       <!-- <label>Role:</label>
       <select v-model="role" class="selection">
         <option class="options" value="admin">Admin</option> 
         <option class="options" value="seller">Product Distrubutor</option>
         <option class="options" value="customer">Customer</option>
       </select> -->
 
       <div class="terms">
         <input type="checkbox" v-model="terms" required>
         <label>Accept terms and conditions</label>
       </div>
 
       <div class="submit">
         <button>Create an account</button>
       </div>
 
   </form>
     <div v-if="signupResponse.status === 'success' " >
       <div class="overlay"></div>
       <div class="modal1">
       <p>Sign up succeed!</p>
       <router-link :to="{name: 'ProfilePage'}" >
         <button @click="buttonFunction(signupResponse)" class="actions">Proceed to your profile?</button>
       </router-link>
       </div>
     </div>

      <div v-else class="errorMsg">
        <h3>{{niceError}}</h3>
      </div> 
      

   </template>
 
 <script>
 import axios from 'axios'
 import {mapState} from 'vuex'
 
 export default {
   data () {
     return {
       signUp:  {
         name: "",
         email: "",
         password: "",
         passwordConfirm: ""
       },
       role: "Customer",
       terms: false,
       responseData: {},
       temp: false,
       niceError: ""
     }
   },
 
   computed:{
     ...mapState(['signupResponse'])
   },
 
   methods: {
     handleSubmit() {
        axios.post('http://localhost:3000/api/v1/users/signup', this.signUp,)
           .then(response => this.$store.commit('setSignUp', response.data),
             this.temp = true
             )
           .catch(error => this.niceError = error.response.data.message)
 
     },
 
     buttonFunction(parameter){
+      console.log(parameter.data.user)
       this.$store.commit('handleToken', parameter.token)
-      this.$store.commit('setUser', parameter.user)
+      this.$store.commit('setUser', parameter.data.user)
       this.$store.commit('userIn')
       
       console.log(this.$store.state.user),
-      console.log(this.$store.state.token)
+      console.log(this.$store.state.userToken)
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
    input, select {
        display: block;
        padding: 10px 6px;
        width: 100%;
        box-sizing: border-box;
        border: none;
        border-bottom: 1px solid #ddd;
        color: black;
    }

    input[type="checkbox"] {
      display: inline-block;
      width: 16px;
      margin: 0 10px 0 0;
      position: relative;
      top: 2px;
    }
    input[type="checkbox"]:hover{
        cursor: pointer;
        color: black;
    }
    input[type="checkbox"]:checked{
        color: black;
        background-color: black;
        accent-color: black;
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
    .selection{
        font-size: 1rem;
        border-radius: 5px;
    }
    .selection:hover{
        background-color: rgba(82, 82, 82, 0.078);
    }
    .options{
        font-style: bold;
        color: white;
        background-color: black;
        padding: 10px;
        margin: 10px 10px;
        border-radius: 2px;
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
         width: 50%;
         background-color: rgb(255, 255, 255);
     }

     .modal1 .actions:hover{
       text-decoration: aqua;
       border:2px solid rgb(0, 0, 0);
     }

     .errorMsg{
       color: red;
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