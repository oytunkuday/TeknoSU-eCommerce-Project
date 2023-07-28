import { ref } from '@vue/reactivity'

const getCategories = () => {
    const Categories = ref([])
    const error = ref(null)

    const load1 = async() => {
      try{
        let response = await fetch('http://localhost:3000/api/v1/categories')
        if(response.status !== 200){
          throw Error('no data available')
        }
        const data = await response.json()
        Categories.value = data.data.categories.filter(el => el.status === 'active')
      }
      catch(err){
        error.value = err.message
        console.log(error.value)
      }
    }

    return{
        Categories, error, load1
    }
}

export default getCategories