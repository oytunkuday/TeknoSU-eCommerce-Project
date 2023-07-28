import { ref } from '@vue/reactivity'

const getCategory = (categoryID) => {
    const Category = ref(null)
    const error = ref(null)

    const load1 = async() => {
      try{
        let response = await fetch('http://localhost:3000/api/v1/categories/' + categoryID)
        if(response.status !== 200){
          throw Error('no data available')
        }
        const data = await response.json()
        Category.value = data.data.categories
      }
      catch(err){
        error.value = err.message
        console.log(error.value)
      }
    }

    return{
        Category, error, load1
    }
}

export default getCategory