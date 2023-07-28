import { ref } from '@vue/reactivity'

const getProduct = (id) => {
    const product = ref([])
    const error = ref(null)

    const load8 = async() => {
      try{
        let response = await fetch('http://localhost:3000/api/v1/products/' + id)
        if(response.status !== 200){
          throw Error('that post does no exist')
        }

        const data = await response.json()
        product.value = data.data.products
      }
      catch(err){
        error.value = err.message
        console.log(error.value)
      }
    }

    return{
        product, error, load8
    }
}

export default getProduct