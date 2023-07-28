import { ref } from '@vue/reactivity'

const getSortedProductsDes = () => {
    const productsSortedDes = ref([])
    const error1 = ref(null)

    const load5 = async() => {
      try{
        let response = await fetch('http://localhost:3000/api/v1/products?sort=-newPrice')
        if(response.status !== 200){
          throw Error('no data available')
        }

        const data = await response.json()
        productsSortedDes.value = data.data.products.filter(el => el.status === 'active')
      }
      catch(err){
        error1.value = err.message
        console.log(error1.value)
      }
    }

    return{
        productsSortedDes, error1, load5
    }
}

export default getSortedProductsDes