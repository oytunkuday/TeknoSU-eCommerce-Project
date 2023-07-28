<template>
<div v-if="!signedIn">
<form @submit.prevent="handleLogin">
      <label>Email:</label>
      <input type="email" required v-model="login.email">

      <label>Password:</label>
      <input type="password" required v-model="login.password">
      <!-- <div class="error" v-if="passwordError">{{passwordError}} </div> -->

      <div class="submit">
        <button>Sign In</button>
      </div>
  </form>

  <div class="new">
    <p>Don't have an account?</p>
    <router-link to="/signin/signup">
    <p>Sign up here</p>
    </router-link>
  </div>
  
</div>
  
  <div v-if="signupResponse.status === 'success' ">
    <div class="overlay"></div>
    <div class="modal1">
       <p>Logged in!</p>
       <router-link :to="{name: 'ProfilePage'}" >
         <button @click="method2(signupResponse)" class="actions">Proceed to your profile?</button>
       </router-link>
     </div>
     </div>

      <div v-else class="errorMsg">
        <h3>{{errorM}}</h3>
      </div> 

  
</template>

<script>
import axios from 'axios'
import { mapState } from 'vuex'

export default {
   data() {
       return{
        login: {
          password : '',
          email : '',
         },
         token: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjYyNmU4OTU3NTA5MjFmMDczNTI3Njg0OCIsImlhdCI6MTY1MjA4NjkxMSwiZXhwIjoxNjU5ODYyOTExfQ.LRLATPMqbizpMS7qOc7H4cuzk68Ff1kIn5AqLvkLjPY",
         success: false,
         //userID: '',
         userRole: '',
         errorBoolean: false,
         errorM: ''
        }
    },
    
    methods: {
      handleLogin() {
        axios.post('http://localhost:3000/api/v1/users/login', this.login,{
          headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer '+ this.token
          },
        })
          .then(response => this.$store.commit('setSignUp', response.data)
          //console.log(response.data)
          //this.$store.commit('setUserID', response.data.data.user._id),
          //this.$store.commit('setSignUp', response.data),
          //console.log(response.data.data.user._id),
          //this.$store.commit('setUserID', response.data.data.user._id),
          //console.log(this.userId),
          //this.userID = response.data.data.user._id,
          //console.log(response.data.data.user._id), 
          //this.$store.commit('setUserID', this.userID), 
          //console.log(response),
          // this.success = true, 
          // this.$store.commit('handleToken', this.token),
          // this.$store.commit('userIn'),
          // this.$store.commit('setUserID', response.data.data.userId),
          // console.log("signed in!"),
          // console.log(this.signedIn),
          //console.log(this.userID),
          //console.log(this.userToken)
          )
          .catch(error => 
          this.errorM = error.response.data.message, this.errorBoolean = true
          )
          
      },

      method2(parameter){
       console.log(parameter.token)
       this.$store.commit('handleToken', parameter.token)
+      this.$store.commit('setUser', parameter.data.user)
       this.$store.commit('userIn')
       //this.$store.commit('initialiseStore')
       
       console.log({user: this.$store.state.user}),
       console.log({userToken: this.$store.state.userToken}),
+      console.log({userId: this.$store.state.user._id})
      }
  },
  computed: {
    ...mapState(['signedIn']),
    ...mapState(['userToken']),
    ...mapState(['userId']),
    ...mapState(['user']),
    ...mapState(['signupResponse'])
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
    new{
        width: 30%;
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