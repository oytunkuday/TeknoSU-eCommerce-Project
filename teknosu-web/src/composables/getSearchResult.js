import { ref } from '@vue/reactivity'

const getSearchResult = (searchKey) => {
    const Result = ref(null)
    const error = ref(null)

    const load2 = async() => {
      try{
        let response = await fetch('http://localhost:3000/api/v1/products/search?name=' + searchKey)
        if(response.status !== 200){
          throw Error('no data available')
        }
        const data = await response.json()
        Result.value = data.data.products
      }
      catch(err){
        error.value = err.message
        console.log(error.value)
      }
    }

    return{
        Result, error, load2
    }
}

export default getSearchResult