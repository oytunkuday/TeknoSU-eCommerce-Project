import { ref } from '@vue/reactivity'

const getSortedSearchResultDes = (searchKey) => {
    const ResultSortedDes = ref(null)
    const error = ref(null)

    const load6 = async() => {
      try{
        let response = await fetch('http://localhost:3000/api/v1/products/search?name=' + searchKey + '&sort=-price')
        if(response.status !== 200){
          throw Error('no data available')
        }
        const data = await response.json()
        ResultSortedDes.value = data.data.products.filter(el => el.status === 'active')
      }
      catch(err){
        error.value = err.message
        console.log(error.value)
      }
    }

    return{
        ResultSortedDes, error, load6
    }
}

export default getSortedSearchResultDes