import { ref } from '@vue/reactivity'

const getReviews = (id) => {
    const Reviews = ref(null)
    const error = ref(null)

    const load1 = async() => {
      try{
        let response = await fetch('http://localhost:3000/api/v1/reviews?product=' + id)
        if(response.status !== 200){
          throw Error('no data available')
        }
        const data = await response.json()
        Reviews.value = data.data.reviews
      }
      catch(err){
        error.value = err.message
        console.log(error.value)
      }
    }

    return{
        Reviews, error, load1
    }
}

export default getReviews