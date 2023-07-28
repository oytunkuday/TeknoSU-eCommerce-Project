<template>
  <div v-if="Reviews.length">
      <div v-for="rev in Reviews" :key="rev._id">
          <div class="revCard" v-if="rev.approved">
              <h2>{{rev.user}}</h2>
              <h3>{{rev.rating}}/5</h3>
              <h4>{{rev.review}}</h4>
          </div>
      </div>
  </div>
  <div v-else>No reviews for this product...</div>
</template>

<script>
import getReviews from '../composables/getReviews'
export default {
    props:["_id"],

    setup(props){
        const{Reviews, error, load1} = getReviews(props._id)

        load1()

        return{Reviews, error}
    }
}
</script>

<style scoped>
.revCard{
    border: 1px solid rgba(0, 0, 0, 0.125);
    box-shadow: 0 4px 8px 0 rgba(0,0,0,0.2);
    border-radius: 7px;
    align-content: center;
    margin: 15px auto;
    width: 80%;
}
</style>