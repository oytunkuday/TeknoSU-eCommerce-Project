<template>
  <div v-if="error">{{error}}</div>
  <div v-if="product">
    <div v-if="!signedIn">
        <h2>You are not signed in!</h2>
        <router-link to="/signin">Sign in here</router-link>
    </div>
  
  <div v-else>
    
      <h2>RATE THE {{ product.name }}</h2>
      <div>
        <img 
            :src="product.imgs[0]"
            alt="Product Image"
            class="image"/>
       <div> 
        <h4>About</h4>
        <p>
         {{ product.description}}
         </p>
         <p>Distributor: {{product.distributor}}</p>
         <p>{{product.stocks}} in stock</p>
       </div>  
      </div>
      <p></p>
      <p>${{ product.price }}</p>
         <div class="card">
          <p align="center"></p>
          <h5>Create a Rating</h5><star-rating :increment="0.5" @update:rating ="setRating"></star-rating>
        
<textarea v-model="userComment" placeholder="Add a comment to your rating"></textarea>
      <button @click="putReview(product._id,userId)" class="button" style="vertical-align:middle"><span>Review </span></button>

         </div>
    
    <div v-if="product.ratingsQuantity === 0" class="idkman">No ratings yet</div>
    <div v-else>Average rating: {{product.ratingsAvg.toPrecision(2)}}/5
    <router-link :to="{name: 'Reviews', params: {_id: product._id}}">
    <button class="btn">See All Reviews</button>
    </router-link>
    </div>
    </div>
  </div>
  
  <div v-if="showModal">
    <div class="overlay"></div>
    <div class="modal1">
       <p>Your review will be approved soon!</p>
       <router-link :to="{name: 'ProfilePage'}" >
         <button class="actions">Proceed to your profile?</button>
       </router-link>
     </div>
     </div>

      <div v-else class="errorMsg">
        <h3>{{errorM}}</h3>
      </div>
    
  
  
    

</template>

<script>

import getProduct from '../composables/getProduct' 
import {mapState, useStore} from 'vuex' 
 import axios from 'axios'
import StarRating from 'vue-star-rating'
export default {
    props:['id'],
    data(){
        return{
            ratingselected:0,
            userComment:"",
            token:"",
            errorM: '',
            errorBoolean: false,
            sexybody:{
                review: "",
                rating: 0,
                product: "",
                user: "user"
            },
            showModal: false
        }
    },
    components: {StarRating},
    setup(props) {
        const store = useStore()
        let token2 = store.state.signupResponse.token
        let nagmeler = store.state.signupResponse.data.user.name
        console.log("MERHABALAR AQ")
        console.log(store.state.signupResponse)
        const{product, error, load8} = getProduct(props.id)

        load8()

        return{nagmeler,token2, product, error}
    },
    methods: { 
        setRating(rating){
            this.ratingselected= rating;
            console.log(rating)
        },
        setReview(review){
            this.userComment= review;
            console.log(review)
        },
        putReview(id,uid){
            this.sexybody.review=this.userComment
            this.sexybody.rating=this.ratingselected
            this.sexybody.product=this.product._id
            this.sexybody.user =this.nagmeler
            console.log(this.sexybody)
            this.token=this.token2
            console.log(this.userComment)
            console.log({token2: this.token2})
            console.log('daddy issues')
            console.log(this.token)
            console.log('mama issues')
            axios.post('http://localhost:3000/api/v1/reviews', this.sexybody,{
          headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer '+ this.token2
          },
        }).then(response => console.log(response),
            this.showModal = true)
        .catch(error => this.errorM=error, this.errorBoolean = true)
            
            
        }
    },

    computed: {
    ...mapState(['enableRemove']),
    ...mapState(['signedIn']),
    ...mapState(['userToken']),
    ...mapState(['userId']),
    ...mapState(['signupResponse'])
  }

}
</script>

<style scoped>
.image{
    width: 40%;
    height: auto;
    margin: 0;
    float: left;
    padding: 0 0;
}
.green{
    color: green;
    padding: 20px;
}
.button {
  display: inline-block;
  border-radius: 4px;
  background-color: #000000;
  border: none;
  width: 18%;
  color: #FFFFFF;
  text-align: center;
  font-size: 10px;
  padding: 10px;
  transition: all 0.5s;
  cursor: pointer;
  margin: 5px;
}

.button span {
  cursor: pointer;
  display: inline-block;
  position: relative;
  transition: 0.5s;
}

.button span:after {
  content: '\00bb';
  position: absolute;
  opacity: 0;
  top: 0;
  right: -20px;
  transition: 0.5s;
}

.button:hover span {
  padding-right: 25px;
}

.button:hover span:after {
  opacity: 1;
  right: 0;
}

.button1 {
  display: inline-block;
  border-radius: 4px;
  background-color: #000000;
  border: none;
  color: #FFFFFF;
  text-align: center;
  font-size: 10px;
  padding: 10px;
  width: 30%;
  transition: all 0.5s;
  cursor: pointer;
  margin: 5px;
  cursor: not-allowed;
}
.btn {
  display: inline-block;
  border-radius: 4px;
  background-color: #000000;
  border: none;
  color: #FFFFFF;
  text-align: center;
  font-size: 10px;
  font-weight: bold;
  padding: 10px;
  width: 30%;
  transition: all 0.5s;
  cursor: pointer;
  margin: 20px;
}

.idkman{
  margin: 20px auto;
  font-size: 20px;
  font-weight: bold;
}

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