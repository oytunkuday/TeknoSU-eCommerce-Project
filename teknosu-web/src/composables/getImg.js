import { ref } from '@vue/reactivity'

const getImg = (id) => {
    const productImg = ref(null)
    const error = ref(null)

    const load188 = async() => {
        
      try
      {
        
        let response = await fetch('http://localhost:3000/api/v1/products/' + id)
        if(response.status !== 200){
          throw Error('that post does no exist')
        }

        const data = await response.json()
        productImg.value= data.data.products.imgs[0]
        console.log("productImg geliyoooo")
        console.log(productImg)
      }
      catch(err){
        error.value = err.message
        console.log(error.value)
      }
    }

    return{
        productImg, error, load188
    }
}

export default getImg