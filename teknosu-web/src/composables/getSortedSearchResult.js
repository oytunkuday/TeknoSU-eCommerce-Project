import { ref } from '@vue/reactivity'

const getSortedSearchResult = (searchKey) => {
    const ResultSorted = ref(null)
    const error = ref(null)

    const load4 = async() => {
      try{
        let response = await fetch('http://localhost:3000/api/v1/products/search?name=' + searchKey + '&sort=price')
        if(response.status !== 200){
          throw Error('no data available')
        }
        const data = await response.json()
        ResultSorted.value = data.data.products.filter(el => el.status === 'active')
      }
      catch(err){
        error.value = err.message
        console.log(error.value)
      }
    }

    return{
        ResultSorted, error, load4
    }
}

export default getSortedSearchResult