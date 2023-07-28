import { ref } from '@vue/reactivity'
import axios from 'axios'

const getWishlist = (token) => {
    const Wishlist = ref(null)
    const error = ref(null)
    const load18 = async() => {
    
    try{
        let response = await axios.get('http://localhost:3000/api/v1/wishlist/getWishlist',{
            headers: {
                authorization: 'Bearer '+ token,
                'Content-Type': 'application/json',
                },
        })
        console.log(response)
            if(response.status < 400){
                console.log("get Wishlist complete")
                const data = response
                Wishlist.value = data.data
                //console.log(Wishlist._rawValue.userId)
                
              }
              else{
                console.log("get Wishlist NOT complete")
                throw Error('that post does no exist')
                
              }
            }
      
              catch(error){

              }
                
        }
    return{
        Wishlist, error, load18
    }
}

export default getWishlist